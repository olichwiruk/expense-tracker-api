# frozen_string_literal: true

module Receipts
  class AnalyzeJob < ApplicationJob
    queue_as :default

    def perform(receipt_id)
      receipt = ::Receipt.find(receipt_id)
      Receipts::AnalyzeService.call(receipt)
    end
  end
end
