require 'spec_helper'

describe PagSeguro::SubscriptionPaymentOrder::Response do
  subject { described_class.new(response, object) }

  let(:object) { PagSeguro::SubscriptionPaymentOrder.new }

  let(:response) do
    double(
      :HttpResponse,
      xml?: true
    )
  end

  context 'when response has errors' do
    before do
      allow(response).
        to receive_messages(
          success?: false,
          error?: true,
          error: Aitch::ResponseError
        )
    end

    it 'must respond false to success?' do
      expect(subject).not_to be_success
    end

    it 'object must have errors' do
      expect{ subject.serialize }.to change{ object.errors }
    end
  end

  context 'when response succeeds' do
    before do
      allow(response).
        to receive_messages(
          success?: true,
          data: File.read('./spec/fixtures/subscription_payment_order/success.xml')
        )
    end

    it 'must respond true to success?' do
      expect(subject).to be_success
    end

    it 'object must not have errors' do
      expect{ subject.serialize }.not_to change{ object.errors.empty? }
    end

    it 'object must be updated with serialized attributes' do
      expect{ subject.serialize }.to change{ object.code }
    end
  end
end
