require 'spec_helper'

describe PagSeguro::Authorization::Collection do
  let(:permission) { double(:permission) }
  let(:authorizations) do
    [
      { code: '1234', created_at: Date.today,  permissions: [permission] },
      { code: '4321', created_at: Date.today,  permissions: [permission, permission] }
    ]
  end
  subject { described_class.new({authorizations: authorizations}) }

  describe "initialization" do
    context "when options[:errors] is present" do
      let(:errors) { double(:errors) }
      subject { described_class.new({errors: errors}) }

      it "sets errors" do
        expect(subject.errors).to eq(errors)
      end

      it "has no authorizations" do
        expect(subject).to be_empty
      end
    end

    context "when options[:authorizations] is present" do
      it { expect(subject).to be_any }
      it { expect(subject).not_to be_empty }

      it "has authorizations instances" do
        subject.each do |installment|
          expect(installment).to be_a(PagSeguro::Authorization)
        end
      end
    end
  end

  describe "#errors" do
    it { expect(subject.errors).to be_a(PagSeguro::Errors) }
    it { expect(subject.errors).to be_empty }
  end

  describe "method delegation" do
    it { is_expected.to respond_to(:each) }
    it { is_expected.to respond_to(:empty?) }
    it { is_expected.to respond_to(:any?) }
  end
end
