require "spec_helper"

describe PagSeguro::Installment do
  it_assigns_attribute :credit_card_brand
  it_assigns_attribute :quantity
  it_assigns_attribute :amount
  it_assigns_attribute :total_amount
  it_assigns_attribute :interest_free

  describe ".find" do
    context "when request succeeds" do
      let(:request) { double("request") }

      it "finds installments by the given amount" do
        expect(PagSeguro::Request).to receive(:get)
          .with("installments?amount=100")
          .and_return(request)
        expect(PagSeguro::Installment).to receive(:load_from_response)
          .with(request)

        PagSeguro::Installment.find(100)
      end

      it "find installments by amount and credit card brand" do
        expect(PagSeguro::Request).to receive(:get)
          .with("installments?amount=100&creditCardBrand=visa")
          .and_return(request)
        expect(PagSeguro::Installment).to receive(:load_from_response)
          .with(request)

        PagSeguro::Installment.find(100, :visa)
      end
    end

    context "when request fails" do
      it "returns response with errors" do
        body = %[<?xml version="1.0"?><errors><error><code>1234</code>
          <message>Sample error</message></error></errors>]
        FakeWeb.register_uri :get, %r[.+], status: [400, "Bad Request"],
          body: body, content_type: "text/xml"
        response = PagSeguro::Installment.find("invalid")

        expect(response).to be_a(PagSeguro::Installment::Response)
        expect(response.errors).to include("Sample error")
      end
    end
  end
end
