require "spec_helper"

describe PagSeguro::TransactionRequest do |variable|
  it_assigns_attribute :currency
  it_assigns_attribute :extra_amount
  it_assigns_attribute :reference
  it_assigns_attribute :notification_url
  it_assigns_attribute :payment_method
  it_assigns_attribute :payment_mode
  it_assigns_attribute :credit_card_token
  it_assigns_attribute :extra_params

  it_ensures_type PagSeguro::Sender, :sender
  it_ensures_type PagSeguro::Shipping, :shipping
  it_ensures_type PagSeguro::Bank, :bank
  it_ensures_type PagSeguro::Holder, :holder
  it_ensures_type PagSeguro::Address, :billing_address

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

  it "sets the bank" do
    bank = PagSeguro::Bank.new
    payment = PagSeguro::TransactionRequest.new(bank: bank)

    expect(payment.bank).to eql(bank)
  end

  it "sets the holder" do
    holder = PagSeguro::Holder.new
    payment = PagSeguro::TransactionRequest.new(holder: holder)

    expect(payment.holder).to eql(holder)
  end

  it "sets the billing address" do
    address = PagSeguro::Address.new
    payment = PagSeguro::TransactionRequest.new(billing_address: address)

    expect(payment.billing_address).to eql(address)
  end

  it "sets the items" do
    payment = PagSeguro::TransactionRequest.new
    expect(payment.items).to be_a(PagSeguro::Items)
  end

  it "sets default currency" do
    payment = PagSeguro::TransactionRequest.new
    expect(payment.currency).to eql("BRL")
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
