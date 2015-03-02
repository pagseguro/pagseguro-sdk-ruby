require "spec_helper"

describe PagSeguro::PreApproval do
  
  describe ".find_by_code" do
    it "finds pre approval by the given code" do
      PagSeguro::PreApproval.stub :load_from_response
      expect(PagSeguro::Request).to receive(:get).with("pre-approvals/notifications/CODE").and_return(double.as_null_object)
      PagSeguro::PreApproval.find_by_notification_code("CODE")
    end
    it "returns response with errors when request fails" do
      body = %[<?xml version="1.0"?><errors><error><code>1234</code><message>Sample error</message></error></errors>]
      FakeWeb.register_uri :get, %r[.+], status: [400, "Bad Request"], body: body, content_type: "text/xml"
      response = PagSeguro::PreApproval.find_by_notification_code("invalid")

      expect(response).to be_a(PagSeguro::PreApproval::Response)
      expect(response.errors).to include("Sample error")
    end
  end

  describe ".find_by_notification_code" do
    it "finds pre approval by the given notificationCode" do
      PagSeguro::PreApproval.stub :load_from_response
      expect(PagSeguro::Request).to receive(:get).with("pre-approvals/CODE").and_return(double.as_null_object)
      PagSeguro::PreApproval.find_by_code("CODE")
    end
  end

  describe "attributes" do
    before do
      body = File.read("./spec/fixtures/pre_approval/success.xml")
      FakeWeb.register_uri :get, %r[.+], body: body, content_type: "text/xml"
    end

    subject(:pre_approval) { PagSeguro::PreApproval.find_by_code("CODE") }

    it { expect(pre_approval).to be_a(PagSeguro::PreApproval) }
    it { expect(pre_approval.sender).to be_a(PagSeguro::Sender) }
  end
end