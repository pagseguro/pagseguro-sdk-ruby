require "spec_helper"

describe PagSeguro::Transaction::StatusCollection do
  let(:statuses) { [PagSeguro::TransactionStatus.new] }

  it "should have a PagSeguro::Errors instance" do
    expect(subject.errors).to be_a(PagSeguro::Errors)
  end

  context "when there are no statuses" do
    before do
      subject.statuses = []
    end

    it "is blank" do
      expect(subject).to be_empty
    end

    it "doesn't have any status" do
      expect(subject).not_to be_any
    end
  end

  context "when there are statuses" do
    before do
      subject.statuses = statuses
    end

    it "is not blank" do
      expect(subject).not_to be_empty
    end

    it "has any status" do
      expect(subject).to be_any
    end

    it "has PagSeguro::TransactionStatus instances" do
      subject.each do |status|
        expect(status).to be_a(PagSeguro::TransactionStatus)
      end
    end
  end
end
