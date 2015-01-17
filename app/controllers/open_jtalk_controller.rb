require 'lame'
require 'open_jtalk'

class OpenJtalkController < ApplicationController
  rescue_from ActionController::ParameterMissing do |e|
    render :nothing => true, :status => :bad_request
  end

  def index
  end

  def synthesis
    raise ActionController::ParameterMissing.new(:text) if params.blank?

    text = params[:text]
    raise ActionController::ParameterMissing.new(:text) if text.blank?
    text.gsub!(/\r\n|\r/, "\n")

    style = params[:style] || "Mei::NORMAL"
    config = "OpenJtalk::Config::#{style}".constantize rescue nil
    raise ActionController::ParameterMissing.new(:style) unless config

    openjtalk = OpenJtalk.load(config.to_hash)

    # header, data = openjtalk.synthesis(openjtalk.normalize_text(text))
    response.headers['Content-Type'] = 'audio/mp3'
    self.response_body = Enumerator.new do |y|
      logger.info("start synthesis: text=#{text}")
      start_at = Time.now
      # initialize
      @encoder = nil
      @data_array = []

      text.each_line do |line|
        line.chomp!
        line.strip!
        next if line.blank?

        logger.debug("line=#{line}")
        header, data = openjtalk.synthesis(openjtalk.normalize_text(line))

        unless @encoder
          @encoder = LAME::Encoder.new
          @encoder.configure do |config|
            config.bitrate = @bit_rate || 128
            config.mode = :mono if header['number_of_channels'] == 1
            config.number_of_channels = header['number_of_channels']
            config.input_samplerate = header['sample_rate']
            config.output_samplerate = header['sample_rate']
          end
        end

        @data_array += data.unpack("v*")
        frame_size = @encoder.framesize
        i = 0
        while i + frame_size < @data_array.length do
          slice = @data_array[i, frame_size]
          i += frame_size

          @encoder.encode_short(slice, slice) do |mp3_data|
            y << mp3_data
          end
        end

        if i < @data_array.length
          @data_array = @data_array[i, @data_array.length]
        else
          @data_array = []
        end
      end

      if @encoder
        if @data_array.length
          @encoder.encode_short(@data_array, @data_array) do |mp3_data|
            y << mp3_data
          end
        end

        @encoder.flush do |flush_frame|
          y << flush_frame
        end
      end

      # dispose
      @encoder = nil
      @data_array = []

      finish_at = Time.now
      logger.info("finish synthesis in #{finish_at - start_at} seconds")
    end
  end
end
