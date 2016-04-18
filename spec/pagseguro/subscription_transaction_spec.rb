require 'spec_helper'

describe PagSeguro::SubscriptionTransaction do
  it_assigns_attribute :code
  it_assigns_attribute :status
  it_assigns_attribute :date

  context '#status_code' do
    before do
      subject.status = :waiting_payment
    end

    it 'must return the code related' do
      expect(subject.status_code).to eq 1
    end
  end

  context 'comparison' do
    let(:params) { {code: '1234', status: :paid, date: Time.new(2016,1,1)} }
    subject { described_class.new(params) }

    it { expect(subject).to eq(PagSeguro::SubscriptionTransaction.new(params)) }
  end
end
