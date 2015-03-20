require "spec_helper"

describe PagSeguro::Session do |variable|
  it_assigns_attribute :id

  describe "#create" do
    context "when request succeeds" do
      let(:request) { double("request") }

      it "creates a payment session" do
        expect(PagSeguro::Request).to receive(:post)
          .with("sessions", "v2")
          .and_return(request)
        expect(PagSeguro::Session).to receive(:load_from_response).with(request)

        PagSeguro::Session.create
      end
    end

    context "when request fails" do
      it "returns response with errors" do
        body = %[<?xml version="1.0"?><errors><error><code>1234</code>
          <message>Sample error</message></error></errors>]
        FakeWeb.register_uri :post, %r[.+], status: [400, "Bad Request"],
          body: body, content_type: "text/xml"
        response = PagSeguro::Session.create

        expect(response).to be_a(PagSeguro::Session::Response)
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
      let(:xml_nodes) { double(:xml_nodes) }
      let(:node) { double(:node) }

      it "loads response" do
        expect(Nokogiri).to receive(:XML).with(response_body).and_return(xml)
        expect(xml).to receive(:css).with("session")
          .and_return(xml_nodes)
        expect(xml_nodes).to receive(:first).and_return(node)
        expect(PagSeguro::Session).to receive(:load_from_xml).with(node)

        PagSeguro::Session.load_from_response(response)
      end
    end

    context "when response fails" do
      let(:response) { double(:response, success?: false) }
      let(:error) { double(:error) }

      it "returns response with errors" do
        expect(PagSeguro::Errors).to receive(:new).with(response)
          .and_return(error)
        expect(PagSeguro::Session::Response).to receive(:new).with(error)

        PagSeguro::Session.load_from_response(response)
      end
    end
  end

  describe ".load_from_xml" do
    let(:xml) { double(:xml) }
    let(:serializer) { double(:serializer) }
    let(:data) { double(:data) }

    it "serializes the xml" do
      expect(PagSeguro::Session::Serializer).to receive(:new).with(xml)
        .and_return(serializer)
      expect(serializer).to receive(:serialize).and_return(data)
      expect(PagSeguro::Session).to receive(:new).with(data)

      PagSeguro::Session.load_from_xml(xml)
    end
  end

end
