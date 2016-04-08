require 'spec_helper'

describe PagSeguro::SubscriptionRetry do
  it_assigns_attribute :subscription_code
  it_assigns_attribute :payment_order_code

  context 'errors attribute' do
    it 'should start with errors' do
      expect(subject.errors).to be_a PagSeguro::Errors
    end

    it 'should start with empty errors' do
      expect(subject.errors).to be_empty
    end
  end

  describe '#create' do
    before do
      subject.subscription_code = '1234'
      subject.payment_order_code = '5678'
      subject.credentials = credentials

      FakeWeb.register_uri(
        :post,
        'https://ws.pagseguro.uol.com.br/pre-approvals/1234/payment-orders/5678/payment?email=user@example.com&token=TOKEN',
        body: ''
      )
    end

    let(:credentials) do
      PagSeguro::AccountCredentials.new('user@example.com', 'TOKEN')
    end

    let(:request) do
      double(
        :Request,
        success?: true,
        xml?: true,
        body: '<paymentResult><transactionCode>1234</transactionCode></paymentResult>'
      )
    end

    it 'sends it to correct url' do
      expect(PagSeguro).to receive(:api_url).with(
        'pre-approvals/1234/payment-orders/5678/payment?email=user@example.com&token=TOKEN'
      ).and_return('https://ws.pagseguro.uol.com.br/pre-approvals/1234/payment-orders/5678/payment?email=user@example.com&token=TOKEN')

      subject.save
    end

    context 'when parsing' do
      it 'create' do
        expect(PagSeguro::Request).to receive(:post_xml).with(
          'pre-approvals/1234/payment-orders/5678/payment', nil, credentials, nil,
          { headers: { "Accept" => "application/vnd.pagseguro.com.br.v1+xml;charset=ISO-8859-1" }}
        ).and_return(request)

        subject.save
      end
    end
  end
end
