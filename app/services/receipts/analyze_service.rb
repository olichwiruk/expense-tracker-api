# frozen_string_literal: true

module Receipts
  class AnalyzeService
    def self.call(receipt)
      receipt.processing!

      sleep(5)

      receipt.status = :success
      receipt.save!
    end
  end
end
