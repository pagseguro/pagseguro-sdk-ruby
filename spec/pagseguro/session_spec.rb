require "spec_helper"

describe PagSeguro::Session do |variable|
  describe "#create" do
    context "when request succeeds" do
      let(:request) { double("request") }

      xit "creates a payment session" do
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
end
