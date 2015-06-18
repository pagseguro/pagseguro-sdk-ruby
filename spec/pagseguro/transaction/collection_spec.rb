require "spec_helper"

describe PagSeguro::Transaction::Collection do
  let(:statuses) { [PagSeguro::TransactionStatus.new] }
  subject { PagSeguro::Transaction::Collection.new }

  it "errors must be a PagSeguro::Errors instance" do
    expect(subject.errors).to be_a(PagSeguro::Errors)
  end

  context "when has no statuses" do
    before do
      subject.statuses=[]
    end

    it "be blank" do
      expect(subject).to be_empty
    end

    it "not be any" do
      expect(subject).not_to be_any
    end
  end

  context "when has statuses" do
    before do
      subject.statuses=statuses
    end

    it "not be blank" do
      expect(subject).not_to be_empty
    end

    it "be any" do
      expect(subject).to be_any
    end

    it "each should return PagSeguro::TransactionStatus instances" do
      subject.each do |status|
        expect(status).to be_a(PagSeguro::TransactionStatus)
      end
    end
  end
end
