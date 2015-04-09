require "spec_helper"

describe PagSeguro::CreditCardTransactionRequest do
  it_assigns_attribute :credit_card_token

  it_ensures_type PagSeguro::TransactionInstallment, :installment
  it_ensures_type PagSeguro::Holder, :holder
  it_ensures_type PagSeguro::Address, :billing_address

  it "sets the transaction installment" do
    installment = PagSeguro::TransactionInstallment.new
    payment = PagSeguro::CreditCardTransactionRequest.new(installment: installment)

    expect(payment.installment).to eql(installment)
  end

  it "sets the holder" do
    holder = PagSeguro::Holder.new
    payment = PagSeguro::CreditCardTransactionRequest.new(holder: holder)

    expect(payment.holder).to eql(holder)
  end

  it "sets the billing address" do
    address = PagSeguro::Address.new
    payment = PagSeguro::CreditCardTransactionRequest.new(billing_address: address)

    expect(payment.billing_address).to eql(address)
  end
end
