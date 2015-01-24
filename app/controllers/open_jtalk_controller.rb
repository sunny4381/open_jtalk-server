require 'lame'
require 'open_jtalk'

class OpenJtalkController < ApplicationController
  rescue_from ActionController::ParameterMissing do
    render nothing: true, status: :bad_request
  end

  def index
  end

  def synthesis
    text = param_text
    config = param_config

    response.headers['Content-Type'] = 'audio/mp3'
    self.response_body = StreamingSynthesizer.new(config, text)
  end

  private

  def param_text
    fail ActionController::ParameterMissing, :text if params.blank?

    text = params[:text]
    fail ActionController::ParameterMissing, :text if text.blank?
    text.gsub!(/\r\n|\r/, "\n")
    text
  end

  def param_config
    style = params[:style] || "Mei::NORMAL"
    config = begin
      "OpenJtalk::Config::#{style}".constantize
    rescue
      nil
    end
    fail ActionController::ParameterMissing, :style unless config
    config
  end
end
