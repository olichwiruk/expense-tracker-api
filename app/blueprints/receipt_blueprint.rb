# frozen_string_literal: true

class ReceiptBlueprint < Blueprinter::Base
  identifier :id

  view :created do
    field :status
  end
end
