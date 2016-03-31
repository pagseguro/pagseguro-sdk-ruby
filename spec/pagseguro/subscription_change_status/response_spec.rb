require 'spec_helper'

describe PagSeguro::SubscriptionChangeStatus::Response do
  subject { described_class.new(response, object) }

  let(:object) { PagSeguro::SubscriptionChangeStatus.new(12345, :active) }

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

    let(:source) { File.read('./spec/fixtures/subscription_change_status/fail.xml') }
    let(:parsed_data) { Nokogiri::XML(source) }

    it 'must change object errors' do
      expect{ subject.serialize }.to change{ object.errors.empty? }.to false
    end
  end
end
