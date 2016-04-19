require 'spec_helper'

describe PagSeguro::SubscriptionTransactions do
  [
    :size,
    :clear,
    :empty?,
    :any?,
    :each,
    :map
  ].each do |method|
    it { is_expected.to respond_to(method) }
  end

  it 'should initialize empty' do
    expect(subject).to be_empty
  end

  context 'adding a new transaction' do
    let(:transaction) { { code: '1234' } }

    it "shouldn't add the same transaction" do
      subject << transaction
      expect{ subject << transaction }.to_not change{ subject.size }
    end

    context 'ensures type the new transaction' do
      it 'can be a hash' do
        expect{ subject << transaction }.to change{ subject.size }.to(1)
      end

      it 'can be a PagSeguro::Document' do
        expect{ subject << PagSeguro::SubscriptionTransaction.new(code: '1234') }.to change{ subject.size }.to(1)
      end
    end
  end
end
