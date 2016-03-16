require 'spec_helper'

describe PagSeguro::SubscriptionPaymentMethod do
  it_assigns_attribute :token
  it_ensures_type PagSeguro::Holder, :holder

  it 'payment_method must be CREDITCARD' do
    expect(subject.type).to eq 'CREDITCARD'
  end
end
