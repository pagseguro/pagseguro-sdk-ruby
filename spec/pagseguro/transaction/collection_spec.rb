require "spec_helper"

describe PagSeguro::Transaction::Collection do
  let(:transactions) { [PagSeguro::Transaction.new] }

  it "should have a PagSeguro::Errors instance" do
    expect(subject.errors).to be_a(PagSeguro::Errors)
  end

  context "when there are no transactions" do
    before do
      subject.transactions = []
    end

    it "is blank" do
      expect(subject).to be_empty
    end

    it "doesn't have any transaction" do
      expect(subject).not_to be_any
    end
  end

  context "when there are transactions" do
    before do
      subject.transactions = transactions
    end

    it "is not blank" do
      expect(subject).not_to be_empty
    end

    it "has any transaction" do
      expect(subject).to be_any
    end

    it "has PagSeguro::Transaction instances" do
      subject.each do |transaction|
        expect(transaction).to be_a(PagSeguro::Transaction)
      end
    end
  end
end
