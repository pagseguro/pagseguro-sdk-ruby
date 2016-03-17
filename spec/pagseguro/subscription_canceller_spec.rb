require 'spec_helper'

describe PagSeguro::SubscriptionCanceller do
  it_assigns_attribute :subscription_code

  context 'errors attribute' do
    it 'should start with errors' do
      expect(subject.errors).to be_a PagSeguro::Errors
    end

    it 'should start with empty errors' do
      expect(subject.errors).to be_empty
    end
  end

  describe '#save' do
    before do
      subject.subscription_code = 'ABC'
      subject.credentials = credentials

      FakeWeb.register_uri(
        :get,
        'https://ws.pagseguro.uol.com.br/v2/pre-approvals/cancel/ABC?email=user@example.com&token=TOKEN',
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
        'v2/pre-approvals/cancel/ABC?email=user@example.com&token=TOKEN'
      ).and_return('https://ws.pagseguro.uol.com.br/v2/pre-approvals/cancel/ABC?email=user@example.com&token=TOKEN')

      subject.save
    end

    it 'cancel' do
      expect(PagSeguro::Request).to receive(:get_with_auth_on_url).with(
        'pre-approvals/cancel/ABC', :v2, credentials
      ).and_return(request)

      subject.save
    end
  end
end
