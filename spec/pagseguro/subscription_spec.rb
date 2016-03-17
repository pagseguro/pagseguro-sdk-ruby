require 'spec_helper'

describe PagSeguro::Subscription do
  it_assigns_attribute :code
  it_assigns_attribute :plan
  it_assigns_attribute :reference

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
        'https://ws.pagseguro.uol.com.br/pre-approvals?email=suporte@lojamodelo.com.br&token=95112EE828D94278BD394E91C4388F20',
        body: ''
      )
    end

    let(:credentials) { PagSeguro::AccountCredentials.new('suporte@lojamodelo.com.br', '95112EE828D94278BD394E91C4388F20') }

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
        with('pre-approvals?email=suporte@lojamodelo.com.br&token=95112EE828D94278BD394E91C4388F20').
        and_return('https://ws.pagseguro.uol.com.br/pre-approvals?email=suporte@lojamodelo.com.br&token=95112EE828D94278BD394E91C4388F20')

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
  end
end
