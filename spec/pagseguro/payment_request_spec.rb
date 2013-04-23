require "spec_helper"

describe PagSeguro::PaymentRequest do
  it_assigns_attribute :currency
  it_assigns_attribute :redirect_url
  it_assigns_attribute :extra_amount
  it_assigns_attribute :reference
  it_assigns_attribute :max_age
  it_assigns_attribute :max_uses
  it_assigns_attribute :notification_url

  it_ensures_type PagSeguro::Sender, :sender
  it_ensures_type PagSeguro::Shipping, :shipping

  it "sets the sender" do
    sender = PagSeguro::Sender.new
    payment = PagSeguro::PaymentRequest.new(sender: sender)

    expect(payment.sender).to eql(sender)
  end

  it "sets the items" do
    payment = PagSeguro::PaymentRequest.new
    expect(payment.items).to be_a(PagSeguro::Items)
  end

  it "sets default currency" do
    payment = PagSeguro::PaymentRequest.new
    expect(payment.currency).to eql("BRL")
  end
end
