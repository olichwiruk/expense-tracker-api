# frozen_string_literal: true

require 'rails_helper'

describe "Upload receipt", type: :request do
  describe "POST /receipts" do
    context "with any valid image file" do
      let(:photo) do
        fixture_file_upload(
          'spec/fixtures/files/receipt.jpg',
          'image/jpeg'
        )
      end

      it "creates receipt and schedules analysis" do
        expect {
          post "/receipts", params: { photo: photo }
        }.to change(Receipt, :count).by(1)

        aggregate_failures "response and side effects" do
          expect(response).to have_http_status(:created)
          receipt_id = response.parsed_body["receiptId"]
          expect(Receipts::AnalyzeJob).to have_been_enqueued.with(receipt_id)
        end
      end
    end

    context "without receipt photo" do
      it "returns bad request errors" do
        post "/receipts"

        aggregate_failures "error response" do
          expect(response).to have_http_status(:bad_request)
          expect(response.parsed_body["errors"]).to be_present
        end
      end
    end

    context "with file that is not an image filetype" do
      let(:file) do
        fixture_file_upload(
          'spec/fixtures/files/file.txt',
          'text/plain'
        )
      end

      it "returns unprocessable content errors" do
        post "/receipts", params: { photo: file }

        aggregate_failures "error response" do
          expect(response).to have_http_status(:unprocessable_content)
          expect(response.parsed_body["errors"]).to be_present
        end
      end
    end
  end
end
