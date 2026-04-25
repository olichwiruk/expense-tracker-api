# frozen_string_literal: true

class RemovePhotoBase64FromReceipts < ActiveRecord::Migration[7.2]
  def change
    remove_column :receipts, :photo_base64, :text
  end
end
