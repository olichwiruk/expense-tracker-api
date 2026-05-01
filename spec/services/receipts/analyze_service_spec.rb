# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Receipts::AnalyzeService do
  let(:receipt) do
    Receipt.new(status: :pending).tap do |r|
      r.photo.attach(
        io: StringIO.new('fake'),
        filename: 'fake.jpg',
        content_type: 'image/jpeg'
      )

      r.save!
    end
  end

  let(:fake_llm_response) do
    Llm::Response.new(
      vendor: 'openai',
      model: 'gpt-4o',
      content: {
        merchant: {
          name: 'Piekarnia',
          address: 'Warszawa, ul. Testowa 1'
        },
        date: '2023-10-15T12:00:00',
        items: [
          {
            raw_name: 'CHLEB RAZ',
            full_name: 'Chleb Razowy',
            category: 'Food',
            quantity: 1.0,
            price: 5.50
          }
        ],
        total_price: 5.50
      },
      request_payload: {
        model: 'gpt-4o',
        messages: [ { role: 'user', content: 'Extract data...' } ]
      },
      response_payload: {
        id: 'chatcmpl-123',
        object: 'chat.completion',
        usage: { prompt_tokens: 120, completion_tokens: 45, total_tokens: 165 }
      },
      input_tokens: 120,
      output_tokens: 45,
      duration_ms: 1500
    )
  end

  let(:adapter_double) { instance_double(Llm::Adapters::OpenAi) }

  before do
    allow(adapter_double).to receive(:extract_structured_data).and_return(fake_llm_response)
  end

  describe '#call' do
    it 'updates receipt status to success and saves LLM payload' do
      service = described_class.new(llm_adapter: adapter_double)

      service.call(receipt)

      receipt.reload

      expect(receipt.status).to eq('success')

      expect(receipt.llm_payload['total_price']).to eq(5.50)
      expect(receipt.llm_payload['merchant']['name']).to eq("Piekarnia")
    end

    it 'transitions receipt to processing status' do
      service = described_class.new(llm_adapter: adapter_double)

      expect(receipt).to receive(:processing!).and_call_original

      service.call(receipt)
    end
  end
end
