require "spec_helper"

describe PagSeguro::TransactionRequest do |variable|
  it_assigns_attribute :currency
  it_assigns_attribute :extra_amount
  it_assigns_attribute :reference
  it_assigns_attribute :notification_url
  it_assigns_attribute :payment_mode
  it_assigns_attribute :extra_params

  it_ensures_type PagSeguro::Sender, :sender
  it_ensures_type PagSeguro::Shipping, :shipping

  it "sets the sender" do
    sender = PagSeguro::Sender.new
    payment = PagSeguro::TransactionRequest.new(sender: sender)

    expect(payment.sender).to eql(sender)
  end

  it "sets shipping" do
    shipping = PagSeguro::Shipping.new
    payment = PagSeguro::TransactionRequest.new(shipping: shipping)

    expect(payment.shipping).to eql(shipping)
  end

  it "sets the items" do
    payment = PagSeguro::TransactionRequest.new
    expect(payment.items).to be_a(PagSeguro::Items)
  end

  it "sets default currency" do
    payment = PagSeguro::TransactionRequest.new
    expect(payment.currency).to eql("BRL")
  end

  describe "#payment_method" do
    it "raises not implemented error" do
      expect { subject.payment_method }.to raise_error(NotImplementedError)
    end
  end

  describe "#extra_params" do
    it "is empty before initialization" do
      expect(subject.extra_params).to eql([])
    end

    it "allows extra parameter addition" do
      subject.extra_params << { extraParam: 'value' }
      subject.extra_params << { itemParam1: 'value1' }

      expect(subject.extra_params).to eql([
        { extraParam: 'value' },
        { itemParam1: 'value1' }
      ])
    end
  end
end
