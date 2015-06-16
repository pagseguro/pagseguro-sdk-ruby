require "spec_helper"

describe PagSeguro::Installment::Collection do
  let(:installments) do
    [
      { amount: "100", card_brand: "visa" },
      { amount: "110", card_brand: "visa" }
    ]
  end
  subject { PagSeguro::Installment::Collection.new }

  describe "initialization" do
    it "errors should be a instance of PagSeguro::Errors" do
      expect(subject.errors).to be_a(PagSeguro::Errors)
    end

    it "delegate empty? to @installments" do
      subject.installments = []
      expect(subject).to be_empty

      subject.installments = installments
      expect(subject).not_to be_empty
    end

    it "delegate any? to @installments" do
      subject.installments = []
      expect(subject).not_to be_any

      subject.installments = installments
      expect(subject).to be_any
    end
  end

  context "#installments=" do
    it "turns array of hash into installments" do
      subject.installments = installments

      subject.each do |installment|
        expect(installment).to be_a(PagSeguro::Installment)
      end
    end
  end
end
