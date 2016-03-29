require 'spec_helper'

shared_examples 'Subscription find' do |path|
  let(:base_url) { PagSeguro.root_uri(:api) }
  let(:extended_url) { [base_url, path].join }

  before do
    FakeWeb.register_uri(
      :get,
      extended_url,
      body: 'OK'
    )
  end

  it 'must send to correct URL' do
    expect(PagSeguro).
      to receive(:api_url).
      with(path).
      and_return(extended_url)

    search
  end

  it 'must to call response and serialize' do
    response = double(:Response)

    expect(PagSeguro::Subscription::Response).
      to receive(:new).
      with(any_args).
      and_return(response)

    allow(response).to receive(:serialize)

    search
  end

  it 'must return a PagSeguro::Subscription object' do
    expect(search).to be_a PagSeguro::Subscription
  end
end

describe PagSeguro::Subscription do
  it_assigns_attribute :code
  it_assigns_attribute :name
  it_assigns_attribute :date
  it_assigns_attribute :tracker
  it_assigns_attribute :status
  it_assigns_attribute :charge
  it_assigns_attribute :plan
  it_assigns_attribute :reference
  it_assigns_attribute :last_event_date

  it_ensures_type PagSeguro::Sender, :sender
  it_ensures_type PagSeguro::SubscriptionPaymentMethod, :payment_method

  context 'errors attribute' do
    it 'should start with errors' do
      expect(subject.errors).to be_a PagSeguro::Errors
    end

    it 'should start with empty errors' do
      expect(subject.errors).to be_empty
    end
  end

  context '#create' do
    before do
      subject.credentials = credentials

      FakeWeb.register_uri(
        :post,
        'https://ws.pagseguro.uol.com.br/pre-approvals?email=user@example.com&token=TOKEN',
        body: ''
      )
    end

    let(:credentials) { PagSeguro::AccountCredentials.new('user@example.com', 'TOKEN') }

    let(:request) do
      double(
        :Request,
        xml?: true,
        success?: true,
        body: '<directPreApproval><code>12345</code></directPreApproval>'
      )
    end

    it 'sends it to correct url' do
      expect(PagSeguro).
        to receive(:api_url).
        with('pre-approvals?email=user@example.com&token=TOKEN').
        and_return('https://ws.pagseguro.uol.com.br/pre-approvals?email=user@example.com&token=TOKEN')

      subject.create
    end

    context 'when parsing' do
      it 'create a subscription' do
        expect(PagSeguro::Request).
          to receive(:post_xml).
          with(
            'pre-approvals',
            nil,
            credentials,
            a_string_matching(/<directPreApproval>/),
            {:headers=>{"Accept"=>"application/vnd.pagseguro.com.br.v1+xml;charset=ISO-8859-1"}}).
          and_return(request)

        subject.create
      end

      it 'update subscription with the new code' do
        allow(PagSeguro::Request).to receive(:post_xml).and_return(request)
        expect { subject.create }.to change { subject.code }.to('12345')
      end
    end

    context 'find subscriptions' do
      let(:code) { 12345 }
      let(:request) { double(:Request, success?: true, xml?: true, body: '') }

      context 'by notification code' do
        let(:search) { PagSeguro::Subscription.find_by_notification_code(code, credentials: credentials) }

        it_behaves_like 'Subscription find',
          'v2/pre-approvals/notifications/12345?email=user@example.com&token=TOKEN'
      end

      context 'subscription code' do
        let(:search) { PagSeguro::Subscription.find_by_code(code, credentials: credentials) }

        it_behaves_like 'Subscription find',
          'v2/pre-approvals/12345?email=user@example.com&token=TOKEN'
      end
    end
  end
end
