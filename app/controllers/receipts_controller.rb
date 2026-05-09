# frozen_string_literal: true

class ReceiptsController < ApplicationController
  def create
    status, result = Receipts::CreateService.call(create_params)

    case status
    when :ok
      render json: { success: true, receiptId: result.id }, status: :created
    when :error
      render json: { errors: result }, status: :unprocessable_content
    end
  end

  private def create_params
    params.require(:photo)
    params.permit(:photo)
  end
end
