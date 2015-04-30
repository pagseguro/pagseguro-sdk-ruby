require "spec_helper"

RSpec.describe "Creating Session" do
  let(:session_response) { PagSeguro::Session.create }

  context "when request succeeds" do
    before do
      FakeWeb.register_uri :post, PagSeguro.api_url("v2/sessions"), body: "",
        content_type: "text/xml"
    end

    it "returns a session response object" do
      expect(session_response).to be_a(PagSeguro::Session::Response)
    end

    describe "#response" do
      it "has a response" do
        expect(session_response.response).to_not be_nil
      end

      it "delegates #success? to response" do
        expect(session_response.success?).to be_truthy
      end
    end

    describe "#errors" do
      it "is an errors object" do
        expect(session_response.errors).to be_a(PagSeguro::Errors)
      end

      it "has no errors" do
        expect(session_response.errors).to be_empty
      end
    end
  end

  context "when request fails" do
    before do
      body = %[<?xml version="1.0"?><errors><error><code>1234</code>
          <message>Sample error</message></error></errors>]
      FakeWeb.register_uri :post, PagSeguro.api_url("v2/sessions"),
        status: [400, "Bad Request"], body: body, content_type: "text/xml"
    end

    it "returns a session response object" do
      expect(session_response).to be_a(PagSeguro::Session::Response)
    end

    describe "#response" do
      it "has a response" do
        expect(session_response.response).to_not be_nil
      end

      it "delegates #success? to response" do
        expect(session_response.success?).to be_falsy
      end
    end

    describe "#errors" do
      it "is an errors object" do
        expect(session_response.errors).to be_a(PagSeguro::Errors)
      end

      it "has errors" do
        expect(session_response.errors).to_not be_empty
      end
    end
  end
end
