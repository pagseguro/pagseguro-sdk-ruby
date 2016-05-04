require 'spec_helper'

describe PagSeguro::SubscriptionPlan do
  it_assigns_attribute :max_users
  it_assigns_attribute :name
  it_assigns_attribute :charge
  it_assigns_attribute :amount
  it_assigns_attribute :max_total_amount
  it_assigns_attribute :max_amount_per_payment
  it_assigns_attribute :max_payments_per_period
  it_assigns_attribute :max_amount_per_period
  it_assigns_attribute :initial_date
  it_assigns_attribute :final_date
  it_assigns_attribute :membership_fee
  it_assigns_attribute :trial_duration
  it_assigns_attribute :period
  it_assigns_attribute :redirect_url
  it_assigns_attribute :review_url
  it_assigns_attribute :reference
  it_assigns_attribute :details

  it_ensures_type PagSeguro::Sender, :sender

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

  context '#url' do
    context 'when it is a manual subscription' do
      before do
        allow(subject).to receive(:charge).and_return('MANUAL')
      end

      context 'and it has code' do
        before do
          allow(subject).to receive(:code).and_return('12345')
        end

        context 'should return correct url with code' do
          it 'to production' do
            PagSeguro.configuration.environment = :production
            expect(subject.url).to eq 'https://pagseguro.uol.com.br/v2/pre-approvals/request.html?code=12345'
          end

          it 'to sandbox' do
            PagSeguro.configuration.environment = :sandbox
            expect(subject.url).to eq 'https://sandbox.pagseguro.uol.com.br/v2/pre-approvals/request.html?code=12345'
          end
        end
      end

      context 'and it has no code' do
        before do
          allow(subject).to receive(:code).and_return(nil)
        end

        it 'should not return url' do
          expect(subject.url).to eq nil
        end
      end
    end
  end
end
