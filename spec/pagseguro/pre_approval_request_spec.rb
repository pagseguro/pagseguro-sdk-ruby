require "spec_helper"

describe PagSeguro::PreApprovalRequest do
  it_assigns_attribute :charge
  it_assigns_attribute :charge
  it_assigns_attribute :details
  it_assigns_attribute :amount_per_payment
  it_assigns_attribute :max_amount_per_payment
  it_assigns_attribute :period
  it_assigns_attribute :max_payments_per_period
  it_assigns_attribute :max_amount_per_period
  it_assigns_attribute :final_date
  it_assigns_attribute :max_total_amount
  it_assigns_attribute :redirect_url
  it_assigns_attribute :reference
  it_assigns_attribute :review_url

  it_ensures_type PagSeguro::Sender, :sender


  it "sets the sender" do
    sender = PagSeguro::Sender.new
    pre_approval = PagSeguro::PreApprovalRequest.new(sender: sender)

    expect(pre_approval.sender).to eql(sender)
  end

  it "sets default charge" do
    pre_approval = PagSeguro::PreApprovalRequest.new
    expect(pre_approval.charge).to eql("manual")
  end

   describe "#register" do
    let(:pre_approval) { PagSeguro::PreApprovalRequest.new }
    before { FakeWeb.register_uri :any, %r[.*?], body: "" }

    it "serializes pre_approval request" do
      PagSeguro::PreApprovalRequest::Serializer
        .should_receive(:new)
        .with(pre_approval)
        .and_return(double.as_null_object)

      pre_approval.register
    end

    it "performs request" do
      params = double

      params.should_receive(:merge).with({
        email: PagSeguro.email,
        token: PagSeguro.token
      }).and_return(params)

      PagSeguro::PreApprovalRequest::Serializer.any_instance.stub to_params: params

      PagSeguro::Request
        .should_receive(:post)
        .with("pre-approvals/request", params)

      pre_approval.register
    end

     it "initializes response" do
      response = double
      PagSeguro::Request.stub post: response

      PagSeguro::PreApprovalRequest::Response
        .should_receive(:new)
        .with(response)

      pre_approval.register
    end

    it "returns response" do
      response = double
      PagSeguro::PreApprovalRequest::Response.stub new: response

      expect(pre_approval.register).to eql(response)
    end
  end

end