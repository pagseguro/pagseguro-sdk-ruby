require "spec_helper"

RSpec.describe "Creating Transaction Request" do
  let(:transaction) { PagSeguro::OnlineDebitTransactionRequest.new }

  context "when request succeeds" do
    before do
      body = File.read("./spec/fixtures/transaction_request/success.xml")
      FakeWeb.register_uri :post, PagSeguro.api_url("v2/transactions"),
        body: body, content_type: "text/xml"
    end

    it "returns true" do
      expect(transaction.create).to be_truthy
    end

    describe "#errors" do
      before do
        transaction.create
      end

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

    it "does not change attributes" do
      expect { transaction.create }.not_to change { transaction.code }
    end

    describe "#errors" do
      before do
        transaction.create
      end

      it "is an errors object" do
        expect(transaction.errors).to be_a(PagSeguro::Errors)
      end

      it "has errors" do
        expect(transaction.errors).to_not be_empty
      end
    end
  end
end
