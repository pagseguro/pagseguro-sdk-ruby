require 'spec_helper'

describe PagSeguro::SubscriptionDiscount do
  it_assigns_attribute :type
  it_assigns_attribute :value

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
      subject.code = '1234'
      subject.credentials = credentials

      FakeWeb.register_uri(
        :put,
        'https://ws.pagseguro.uol.com.br/pre-approvals/1234/discount?email=user@example.com&token=TOKEN',
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
        body: '<preApprovalRequest><code>1234</code></preApprovalRequest>'
      )
    end

    it 'sends it to correct url' do
      expect(PagSeguro).to receive(:api_url).with(
        'pre-approvals/1234/discount?email=user@example.com&token=TOKEN'
      ).and_return('https://ws.pagseguro.uol.com.br/pre-approvals/1234/discount?email=user@example.com&token=TOKEN')

      subject.create
    end

    context 'when parsing' do
      it 'create a discount' do
        expect(PagSeguro::Request).to receive(:put_xml).with(
          'pre-approvals/1234/discount', credentials, a_string_matching(/<directPreApproval>/)
        ).and_return(request)

        subject.create
      end
    end
  end
end
