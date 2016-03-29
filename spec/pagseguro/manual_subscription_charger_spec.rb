require 'spec_helper'

describe PagSeguro::ManualSubscriptionCharger do
  it_assigns_attribute :reference
  it_assigns_attribute :subscription_code
  it_assigns_attribute :transaction_code

  it_ensures_collection_type PagSeguro::Item, :items, [{id: '123', description: 'abc', amount: 100.00, quantity: 1}]

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
      subject.credentials = credentials

      FakeWeb.register_uri(
        :post,
        'https://ws.pagseguro.uol.com.br/v2/pre-approvals/payment?email=user@example.com&token=TOKEN',
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
        body: '<result><transactionCode>1234</transactionCode><date>2011-08-19T14:47:59.000-03:00</date></result>'
      )
    end

    it 'sends it to correct url' do
      expect(PagSeguro).to receive(:api_url).with(
        'v2/pre-approvals/payment?email=user@example.com&token=TOKEN'
      ).and_return('https://ws.pagseguro.uol.com.br/v2/pre-approvals/payment?email=user@example.com&token=TOKEN')

      subject.create
    end

    context 'when creating' do
      it 'send to correct url' do
        expect(PagSeguro::Request).to receive(:post_xml).with(
          'pre-approvals/payment', :v2, credentials, a_string_matching(/<payment>/)
        ).and_return(request)

        subject.create
      end

      it 'update with the new transaction_code' do
        allow(PagSeguro::Request).to receive(:post_xml).and_return(request)

        expect { subject.create }.to change { subject.transaction_code }.to('1234')
      end
    end
  end
end
