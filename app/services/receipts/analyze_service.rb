# frozen_string_literal: true

module Receipts
  class AnalyzeService
    attr_reader :llm_adapter

    def initialize(llm_adapter:)
      @llm_adapter = llm_adapter
    end

    def call(receipt)
      receipt.processing!

      llm_response = llm_adapter.extract_structured_data(
        image: receipt.photo,
        schema: ::Receipts::ExtractedData
      )

      extracted_data = Receipts::ExtractedData.new(llm_response.content)

      receipt.llm_payload = extracted_data.to_h
      receipt.status = :success
      receipt.save!
    end
  end
end
