class Preprocessor
  include Enumerable

  def initialize(text)
    @text = text
  end

  def each
    e = @text.each_line
    e = e.lazy if e.respond_to?(:lazy)

    # remove whites
    e = e.map do |line|
      line.chomp!
      line.strip!
      line
    end

    # filter out blanks
    e = e.select(&:present?)

    e.each do |line|
      yield line
    end
  end
end
