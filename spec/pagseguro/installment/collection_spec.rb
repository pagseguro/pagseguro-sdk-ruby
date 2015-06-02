require "spec_helper"

describe PagSeguro::Installment::Collection do
  let(:installments) do
    [
      { amount: "100", card_brand: "visa" },
      { amount: "110", card_brand: "visa" }
    ]
  end
  subject { described_class.new({installments: installments}) }

  describe "initialization" do
    context "when options[:errors] is present" do
      let(:errors) { double(:errors) }
      subject { described_class.new({errors: errors}) }

      it "sets errors" do
        expect(subject.errors).to eq(errors)
      end

      it "has no installments" do
        expect(subject).to be_empty
      end
    end

    context "when options[:installments] is present" do
      it { expect(subject).to be_any }
      it { expect(subject).not_to be_empty }

      it "has installments instances" do
        subject.each do |installment|
          expect(installment).to be_a(PagSeguro::Installment)
        end
      end
    end
  end

  describe "#errors" do
    it { expect(subject.errors).to be_a(PagSeguro::Errors) }
    it { expect(subject.errors).to be_empty }
  end

  describe "method delegation" do
    it { subject.respond_to? (:each) }
    it { subject.respond_to? (:empty?) }
    it { subject.respond_to? (:any?) }
  end
end
