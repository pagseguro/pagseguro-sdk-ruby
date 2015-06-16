require "spec_helper"

describe PagSeguro::Installment do
  it_assigns_attribute :card_brand
  it_assigns_attribute :quantity
  it_assigns_attribute :amount
  it_assigns_attribute :total_amount
  it_assigns_attribute :interest_free

  describe ".find" do
    context "when request succeeds" do
      let(:request) { double("request") }
      let(:version) { 'v2' }

      it "finds installments by the given amount" do
        expect(PagSeguro::Request).to receive(:get)
          .with("installments?amount=100.00", version)
          .and_return(request)
        expect(PagSeguro::Installment).to receive(:load_from_response)
          .with(request)

        PagSeguro::Installment.find("100.00")
      end

      it "find installments by amount and credit card brand" do
        expect(PagSeguro::Request).to receive(:get)
          .with("installments?amount=100.00&cardBrand=visa", version)
          .and_return(request)
        expect(PagSeguro::Installment).to receive(:load_from_response)
          .with(request)

        PagSeguro::Installment.find("100.00", :visa)
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

  describe ".load_from_response" do
    context "when response succeeds" do
      let(:response_body) { double(:response_body) }
      let(:response) do
        double(:response, success?: true, xml?: true, body: response_body)
      end
      let(:xml) { double(:xml) }
      let(:node) { double(:node) }
      let(:installments_nodes) { [node] }

      it "loads response" do
        expect(Nokogiri).to receive(:XML).with(response_body).and_return(xml)
        expect(xml).to receive(:css).with("installments > installment")
          .and_return(installments_nodes)
        expect(PagSeguro::Installment).to receive(:load_from_xml).with(node)

        PagSeguro::Installment.load_from_response(response)
      end
    end

    context "when response fails" do
      let(:response) { double(:response, success?: false) }
      let(:error) { double(:error) }

      it "returns response with errors" do
        expect(PagSeguro::Errors).to receive(:new).with(response)
          .and_return(error)
        expect(PagSeguro::Installment::Response).to receive(:new).with(error)

        PagSeguro::Installment.load_from_response(response)
      end
    end
  end

  describe ".load_from_xml" do
    let(:xml) { double(:xml) }
    let(:serializer) { double(:serializer) }
    let(:data) { double(:data) }

    it "serializes the xml" do
      expect(PagSeguro::Installment::Serializer).to receive(:new).with(xml)
        .and_return(serializer)
      expect(serializer).to receive(:serialize).and_return(data)
      expect(PagSeguro::Installment).to receive(:new).with(data)

      PagSeguro::Installment.load_from_xml(xml)
    end
  end
end
