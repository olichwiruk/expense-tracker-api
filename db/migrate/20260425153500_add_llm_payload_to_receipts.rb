# frozen_string_literal: true

class AddLlmPayloadToReceipts < ActiveRecord::Migration[7.2]
  def change
    add_column :receipts, :llm_payload, :jsonb

    add_index :receipts, :llm_payload, using: :gin
  end
end
