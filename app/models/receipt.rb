# frozen_string_literal: true

class Receipt < ApplicationRecord
  has_one_attached :photo

  enum :status, { pending: 0, processing: 1, success: 2, failed: 3 }

  validates :status, presence: true
  validates :photo, attached: true,
    content_type: [ "image/png", "image/jpeg" ],
    size: { less_than: 5.megabytes }
end
