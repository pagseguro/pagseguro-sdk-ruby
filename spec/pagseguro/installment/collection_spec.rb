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
        expect(subject.empty?).to be_truthy
      end
    end

    context "when options[:installments] is present" do
      it { expect(subject.any?).to be_truthy }
      it { expect(subject.empty?).to be_falsey }

      it "has installments instances" do
        subject.each do |installment|
          expect(installment).to be_a(PagSeguro::Installment)
        end
      end
    end
  end

  describe "#errors" do
    it { expect(subject.errors).to be_a(PagSeguro::Errors) }
    it { expect(subject.errors.empty?).to be_truthy }
  end

  describe "method delegation" do
    it { subject.respond_to? (:each) }
    it { subject.respond_to? (:empty?) }
    it { subject.respond_to? (:any?) }
  end
end
