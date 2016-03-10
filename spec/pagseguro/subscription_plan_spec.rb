require 'spec_helper'

describe PagSeguro::SubscriptionPlan do
  it_assigns_attribute :max_users
  it_assigns_attribute :name
  it_assigns_attribute :charge
  it_assigns_attribute :amount
  it_assigns_attribute :max_amount
  it_assigns_attribute :final_date
  it_assigns_attribute :membership_fee
  it_assigns_attribute :trial_duration

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
        'https://ws.pagseguro.uol.com.br/v2/pre-approvals/request?email=user@example.com&token=TOKEN',
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
        'v2/pre-approvals/request?email=user@example.com&token=TOKEN'
      ).and_return('https://ws.pagseguro.uol.com.br/v2/pre-approvals/request?email=user@example.com&token=TOKEN')

      subject.create
    end

    context 'when parsing' do
      it 'create a plan' do
        expect(PagSeguro::Request).to receive(:post_xml).with(
          'pre-approvals/request', 'v2', credentials, a_string_matching(/<preApprovalRequest>/)
        ).and_return(request)

        subject.create
      end

      it 'update plan with the new code' do
        allow(PagSeguro::Request).to receive(:post_xml).and_return(request)

        expect { subject.create }.to change { subject.code }.to('1234')
      end
    end
  end
end
