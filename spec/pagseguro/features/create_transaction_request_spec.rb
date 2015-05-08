require "spec_helper"

RSpec.describe "Creating Transaction Request" do
  let(:transaction) { PagSeguro::OnlineDebitTransactionRequest.new.create }

  context "when request succeeds" do
    before do
      FakeWeb.register_uri :post, PagSeguro.api_url("v2/transactions"), body: ""
    end

    it "returns a transaction request response object" do
      expect(transaction).to be_a(PagSeguro::TransactionRequest::Response)
    end

    it "has a response" do
      expect(transaction.response).to_not be_nil
    end

    describe "#errors" do
      it "is an errors object" do
        expect(transaction.errors).to be_a(PagSeguro::Errors)
      end

      it "has no errors" do
        expect(transaction.errors).to be_empty
      end
    end
  end

  context "when request fails" do
    before do
      body = %[<?xml version="1.0"?><errors><error><code>1234</code>
          <message>Sample error</message></error></errors>]
      FakeWeb.register_uri :post, PagSeguro.api_url("v2/transactions"),
        status: [400, "Bad Request"], body: body, content_type: "text/xml"
    end

    it "returns a transaction request response object" do
      expect(transaction).to be_a(PagSeguro::TransactionRequest::Response)
    end

    it "has a response" do
      expect(transaction.response).to_not be_nil
    end

    describe "#errors" do
      it "is an errors object" do
        expect(transaction.errors).to be_a(PagSeguro::Errors)
      end

      it "has errors" do
        expect(transaction.errors).to_not be_empty
      end
    end
  end
end
