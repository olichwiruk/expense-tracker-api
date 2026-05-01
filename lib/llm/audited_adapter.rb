# frozen_string_literal: true

module Llm
  class AuditedAdapter
    attr_reader :base_adapter, :auditable

    def initialize(base_adapter, auditable)
      @base_adapter = base_adapter
      @auditable = auditable
    end

    def extract_structured_data(image:, schema:)
      response = base_adapter.extract_structured_data(
        image: image,
        schema: schema
      )

      log_attempt(response)

      response
    rescue => e
      log_failed_attempt(e)
      raise e
    end

    private def log_attempt(response)
      auditable.llm_attempts.create!(
        vendor: response.vendor,
        llm_model_name: response.model,
        status: "success",
        request_payload: response.request_payload,
        response_payload: response.response_payload,
        input_tokens: response.input_tokens,
        output_tokens: response.output_tokens,
        duration_ms: response.duration_ms
      )
    end

    private def log_failed_attempt(error)
      auditable.llm_attempts.create!(
        status: "failure",
        error_message: error.message
      )
    end
  end
end
