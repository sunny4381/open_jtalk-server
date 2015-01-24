require 'lame'
require 'open_jtalk'

class StreamingSynthesizer
  include Enumerable

  def initialize(config, text)
    @config = config
    @text = text
    @encoder = nil
    @pending_slice = []
  end

  def each
    Rails.logger.debug("start synthesis: text=#{@text}")
    start_at = Time.now

    e = Preprocessor.new(@text)

    OpenJtalk.load(@config.to_hash) do |openjtalk|
      e.each do |line|
        header, pcm_data = openjtalk.synthesis(openjtalk.normalize_text(line))

        @encoder = self.class.create_encoder(header) unless @encoder
        frame_size = @encoder.framesize

        @pending_slice += pcm_data.unpack("v*")
        pending_slice = nil
        @pending_slice.each_slice(frame_size) do |slice|
          if slice.length == frame_size
            @encoder.encode_short(slice, slice) do |mp3_data|
              yield mp3_data
            end
          else
            pending_slice = slice
          end
        end

        @pending_slice = pending_slice.present? ? pending_slice : []
      end
    end

    if @encoder
      if @pending_slice.present?
        @encoder.encode_short(@pending_slice, @pending_slice) do |mp3_data|
          yield mp3_data
        end
      end

      @encoder.flush do |flush_frame|
        yield flush_frame
      end
    end

    # dispose
    @encoder = nil
    @pending_slice = []

    finish_at = Time.now
    Rails.logger.info("synthesize #{@text} in #{finish_at - start_at} seconds")
  end

  def self.create_encoder(header)
    encoder = LAME::Encoder.new
    encoder.configure do |config|
      config.bitrate = @bit_rate || 128
      config.mode = :mono if header['number_of_channels'] == 1
      config.number_of_channels = header['number_of_channels']
      config.input_samplerate = header['sample_rate']
      config.output_samplerate = header['sample_rate']
    end
    encoder
  end
end
