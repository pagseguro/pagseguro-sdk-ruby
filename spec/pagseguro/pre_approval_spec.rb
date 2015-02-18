require "spec_helper"

describe PagSeguro::PreApproval do
  
  describe ".find_by_code" do
    it "finds pre approval by the given code" do
      PagSeguro::PreApproval.stub :load_from_response
      expect(PagSeguro::Request).to receive(:get).with("pre-approvals/notifications/CODE").and_return(double.as_null_object)
      PagSeguro::PreApproval.find_by_notification_code("CODE")
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
    # it { expect(pre_approval.shipping).to be_a(PagSeguro::Shipping) }
    # it { expect(pre_approval.items).to be_a(PagSeguro::Items) }
    # it { expect(pre_approval.payment_method).to be_a(PagSeguro::PaymentMethod) }
    # it { expect(pre_approval.status).to be_a(PagSeguro::PaymentStatus) }
    # it { expect(pre_approval.items.size).to eq(1) }
    # it { expect(pre_approval).to respond_to(:escrow_end_date) }
  end
end