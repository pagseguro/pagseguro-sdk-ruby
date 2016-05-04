require 'spec_helper'

describe PagSeguro::SubscriptionPaymentOrder do
  it_assigns_attribute :code
  it_assigns_attribute :status
  it_assigns_attribute :amount
  it_assigns_attribute :gross_amount
  it_assigns_attribute :last_event_date
  it_assigns_attribute :scheduling_date

  it_ensures_type PagSeguro::SubscriptionDiscount, :discount
  it_ensures_collection_type PagSeguro::SubscriptionTransaction, :transactions, [{code: '1234'}]

  it '#udpate_attributes' do
    expect{ subject.update_attributes(code: '1234') }.to change{ subject.code }.to '1234'
  end

  context '#status_code' do
    before do
      subject.status = :scheduled
    end

    it 'must return the code related' do
      expect(subject.status_code).to eq 1
    end
  end
end
