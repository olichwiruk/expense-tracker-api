# frozen_string_literal: true

module Receipts
  class CreateService
    def self.call(params)
      receipt = Receipt.new(name: params[:name])

      if receipt.save
        Receipts::AnalyzeJob.perform_later(receipt.id)

        [ :ok, receipt ]
      else
        [ :error, receipt.errors.full_messages ]
      end
    end
  end
end
