# frozen_string_literal: true

module Receipts
  class AnalyzeService
    def self.call(receipt)
      receipt.processing!

      llm_adapter = Llm::Adapters::OpenAi.new
      result = llm_adapter.extract_structured_data(image: receipt.photo)

      receipt.llm_payload = result.content
      receipt.status = :success
      receipt.save!
    end
  end
end
