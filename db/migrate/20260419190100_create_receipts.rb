# frozen_string_literal: true

class CreateReceipts < ActiveRecord::Migration[7.2]
  def change
    create_table :receipts do |t|
      t.string :name
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
