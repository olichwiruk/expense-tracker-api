# frozen_string_literal: true

class ReceiptsController < ApplicationController
  def create
    status, result = Receipts::CreateService.call(create_params)

    case status
    when :ok
      render json: { success: true, receiptId: result.id }, status: :accepted
    when :error
      render json: { errors: result }, status: :unprocessable_entity
    end
  end

  private def create_params
    params.permit(:photo)
  end
end
