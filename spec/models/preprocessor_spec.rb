# encoding: utf-8
require 'rails_helper'

describe Preprocessor do
  describe "#each" do
    context "when 'a\\nb\\nc' is given" do
      subject { Preprocessor.new("a\nb\nc") }
      it { expect(subject.count).to eq 3 }
    end

    context "when 'a\\n \\nc' is given" do
      subject { Preprocessor.new("a\n \nc") }
      it { expect(subject.count).to eq 2 }
    end

    context "when ' a\\nb \\n c ' is given" do
      subject { Preprocessor.new(" a\nb \n c ").to_a }
      it { expect(subject).to include("a") }
      it { expect(subject).to include("b") }
      it { expect(subject).to include("c") }
    end
  end
end
