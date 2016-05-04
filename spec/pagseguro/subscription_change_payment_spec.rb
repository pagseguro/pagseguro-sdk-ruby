require 'spec_helper'

describe PagSeguro::SubscriptionChangePayment do
  it_assigns_attribute :subscription_code

  it_ensures_type PagSeguro::Sender, :sender
  it_ensures_type PagSeguro::SubscriptionPaymentMethod, :subscription_payment_method

  subject do
    described_class.new(subscription_code: '12345')
  end

  let(:credentials) { PagSeguro::AccountCredentials.new('user@example.com', 'TOKEN') }

  before do
    subject.credentials = credentials
  end

  context 'errors attribute' do
    it 'should start with errors' do
      expect(subject.errors).to be_a PagSeguro::Errors
    end

    it 'should start with empty errors' do
      expect(subject.errors).to be_empty
    end
  end

  context '#update' do
    context 'when succeed' do
      before do
        FakeWeb.register_uri(
          :put,
          "https://ws.pagseguro.uol.com.br/pre-approvals/12345/payment-method?email=user@example.com&token=TOKEN",
          status: ['204', 'No Content']
        )
      end

      it 'errors must not be present' do
        expect{ subject.update }.to_not change{ subject.errors.empty? }
      end
    end

    context 'when fails' do
      before do
        FakeWeb.register_uri(
          :put,
          'https://ws.pagseguro.uol.com.br/pre-approvals/12345/payment-method?email=user@example.com&token=TOKEN',
          body: File.read('./spec/fixtures/subscription_change_payment/fail.xml'),
          status: ['400', 'Bad Request'],
          content_type: 'text/xml'
        )
      end

      it 'should change errors' do
        expect { subject.update }.to change { subject.errors.empty? }.to false
      end
    end
  end
end
