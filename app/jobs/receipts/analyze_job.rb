# frozen_string_literal: true

module Receipts
  class AnalyzeJob < ApplicationJob
    queue_as :default

    def perform(receipt_id)
      receipt = ::Receipt.find(receipt_id)
      service = Receipts::AnalyzeService.new(
        llm_adapter: Llm::AuditedAdapter.new(
          Llm::Adapters::OpenAi.new,
          receipt
        )
      )
      service.call(receipt)
    end
  end
end
