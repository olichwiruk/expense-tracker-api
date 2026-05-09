# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing do |e|
    render json: { errors: [ e.message ] }, status: :bad_request
  end
end
