# encoding: utf-8
require 'rails_helper'
require 'lame'
require 'open_jtalk'

describe StreamingSynthesizer do
  describe "#each" do
    context "when" do
      subject { StreamingSynthesizer.new(OpenJtalk::Config::Mei::NORMAL, "僕、ミッキーだよ。") }

      it do
        subject.each do |mp3_data|
          expect(mp3_data.present?).to be_truthy
        end
      end
    end
  end
end
