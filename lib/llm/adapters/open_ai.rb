# frozen_string_literal: true

module Llm
  module Adapters
    class OpenAi
      attr_reader :client

      def initialize(api_key: ENV.fetch("OPENAI_API_KEY", nil), default_model: "gpt-5-mini")
        @client = RubyLLM.context do |config|
          config.openai_api_key = api_key
          config.default_model = default_model
        end
      end

      def extract_structured_data(image:)
        chat = client.chat.with_instructions(
          "You are an engine for extracting data from receipt images"
        )
          .with_schema(receipt_schema)

        chat
          .ask(
            "Extract merchant data, all items with full names and assign category",
            with: image
          )
      end

      private def receipt_schema
        {
          name: "receipt_extraction",
          strict: true,
          schema: {
            type: "object",
            properties: {
              merchant: {
                type: "object",
                properties: {
                  name: { type: "string" },
                  address: { type: "string" }
                },
                required: [ "name", "address" ],
                additionalProperties: false
              },
              date: {
                type: "string",
                description: "The date of the receipt in ISO 8601 format"
              },
              items: {
                type: "array",
                items: {
                  type: "object",
                  properties: {
                    raw_name: {
                      type: "string",
                      description: "The exact text as it appears on the receipt"
                    },
                    full_name: {
                      type: "string",
                      description: "The full, human-readable product name expanded from abbreviations (e.g., expand 'MLEK SOJ' to 'Mleko Sojowe' or 'CHLEB RAZ' to 'Chleb Razowy')"
                    },
                    category: { type: "string" },
                    quantity: { type: "number" },
                    price: { type: "number", description: "Unit price or total price for the item" }
                  },
                  required: [ "raw_name", "full_name", "category", "quantity", "price" ],
                  additionalProperties: false
                }
              },
              total_price: { type: "number" }
            },
            required: [ "merchant", "date", "items", "total_price" ],
            additionalProperties: false
          }
        }
      end
    end
  end
end
