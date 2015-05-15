require "spec_helper"

RSpec.describe "Creating Session" do
  let(:session) { PagSeguro::Session.create }

  context "when request succeeds" do
    before do
      body = %[<?xml version="1.0"?><session>
        <id>620f99e348c24f07877c927b353e49d3</id></session>]
      FakeWeb.register_uri :post, PagSeguro.api_url("v2/sessions"), body: body,
        content_type: "text/xml"
    end

    it "returns a session object" do
      expect(session).to be_a(PagSeguro::Session)
    end

    describe "#errors" do
      it "is an errors object" do
        expect(session.errors).to be_a(PagSeguro::Errors)
      end

      it "has no errors" do
        expect(session.errors).to be_empty
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

    it "returns a session object" do
      expect(session).to be_a(PagSeguro::Session)
    end

    describe "#errors" do
      it "is an errors object" do
        expect(session.errors).to be_a(PagSeguro::Errors)
      end

      it "has errors" do
        expect(session.errors).to_not be_empty
        expect(session.errors).to include("Sample error")
      end
    end
  end
end
