require "spec_helper"

describe PagSeguro::OnlineDebitTransactionRequest do
  it_ensures_type PagSeguro::Bank, :bank

  describe "#payment_method" do
    it "is online_debit" do
      expect(subject.payment_method).to eq("online_debit")
    end
  end

  it "sets the bank" do
    bank = PagSeguro::Bank.new
    payment = described_class.new(bank: bank)

    expect(payment.bank).to eq(bank)
  end
end
