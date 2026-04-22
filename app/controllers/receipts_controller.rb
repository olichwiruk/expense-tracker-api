# frozen_string_literal: true

class ReceiptsController < ApplicationController
  def create
    errors = validate_upload_params

    return render json: { errors: errors }, status: :bad_request if errors.any?

    status, result = Receipts::CreateService.call(params)

    case status
    when :ok
      render json: { success: true, receiptId: result.id }, status: :accepted
    when :error
      render json: { errors: result }, status: :unprocessable_entity
    end
  end

  private def validate_upload_params
    errors = []
    name = params[:name]

    errors << "Name is missing" if name.blank?
    errors << "Name must be a string" unless name.is_a? String
    errors << "Name is too short" if name.to_s.length < 3
    errors << "Name is too long" if name.to_s.length > 39

    errors
  end
end
