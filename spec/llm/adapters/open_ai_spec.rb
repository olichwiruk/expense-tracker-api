# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Llm::Adapters::OpenAi, :vcr do
  describe "#extract_structured_data" do
    it "returns structured data" do
      adapter = described_class.new
      receipt_path = Rails.root.join('spec/fixtures/files/receipt.jpg')

      result = adapter.extract_structured_data(image: receipt_path)

      expect(result.vendor).to eq("openai")
      expect(result.content).to be_a(Hash)
      expect(result.content).to include("total_price", "merchant")
    end
  end
end
