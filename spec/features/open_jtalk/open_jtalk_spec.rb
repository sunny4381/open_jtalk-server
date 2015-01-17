require 'rails_helper'

describe "open_jtalk" do
  describe "#index" do
    it "returns 200 ok" do
      visit index_path
      expect(status_code).to eq 200
    end
  end

  describe "#synthesis" do
    context "without text parameter" do
      it "returns 400 ok" do
        visit synthesis_path
        expect(status_code).to eq 400
      end
    end

    context "with text parameter" do
      it "returns 200 ok" do
        visit synthesis_path(text: 'おはよう。')
        expect(status_code).to eq 200
      end
    end

    context "without invalid style parameter" do
      it "returns 400 ok" do
        visit synthesis_path(text: 'おはよう。', style: 'XYZ')
        expect(status_code).to eq 400
      end
    end

    context "with multi-line text parameter" do
      it "returns 200 ok" do
        visit synthesis_path(text: 'おはよう。\nこんにちは。')
        expect(status_code).to eq 200
      end
    end
  end
end
