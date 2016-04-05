require 'spec_helper'

describe PagSeguro::SubscriptionChangePayment::Response do
  subject { described_class.new(response, object) }

  let(:object) { PagSeguro::SubscriptionChangePayment.new(subscription_code: '1234') }

  context 'when request succeeds' do
    let(:response) do
      double(
        :Response,
        xml?: true,
        success?: true
      )
    end

    it 'not change object errors' do
      expect{ subject.serialize }.to_not change{ object.errors.empty? }
    end
  end

   context 'when request fails' do
    let(:response) do
      double(
        :Response,
        xml?: true,
        error?: true,
        error: Aitch::BadRequestError,
        success?: false,
        data: parsed_data
      )
    end

    let(:source) { File.read('./spec/fixtures/subscription_change_payment/fail.xml') }
    let(:parsed_data) { Nokogiri::XML(source) }

    it 'must change object errors' do
      expect { subject.serialize }.to change { object.errors.empty? }.to false
    end
  end
end
