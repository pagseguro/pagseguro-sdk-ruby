require "spec_helper"

describe PagSeguro::Transaction::Collection do
  let(:transactions) { [PagSeguro::TransactionStatus.new] }
  subject { PagSeguro::Transaction::Collection.new }

  it "errors must be a PagSeguro::Errors instance" do
    expect(subject.errors).to be_a(PagSeguro::Errors)
  end

  context "when has no transactions" do
    before do
      subject.transactions=[]
    end

    it "be blank" do
      expect(subject).to be_empty
    end

    it "not be any" do
      expect(subject).not_to be_any
    end
  end

  context "when has transactions" do
    before do
      subject.transactions=transactions
    end

    it "not be blank" do
      expect(subject).not_to be_empty
    end

    it "be any" do
      expect(subject).to be_any
    end

    it "each should return transaction instances" do
      subject.each do |transaction|
        expect(transaction).to be_a(PagSeguro::TransactionStatus)
      end
    end
  end
end
