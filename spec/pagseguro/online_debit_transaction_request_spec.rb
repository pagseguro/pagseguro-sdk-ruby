require "spec_helper"

describe PagSeguro::OnlineDebitTransactionRequest do
  it_ensures_type PagSeguro::Bank, :bank

  it "sets the bank" do
    bank = PagSeguro::Bank.new
    payment = PagSeguro::OnlineDebitTransactionRequest.new(bank: bank)

    expect(payment.bank).to eq(bank)
  end
end
