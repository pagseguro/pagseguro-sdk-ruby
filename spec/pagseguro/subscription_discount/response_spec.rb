require 'spec_helper'

RSpec.describe PagSeguro::SubscriptionDiscount::Response do
  subject { described_class.new(response, discount) }

  let(:discount) { PagSeguro::SubscriptionDiscount.new }

  context '#success?' do
    let(:response) do
      double(:HttpResponse, xml?: true)
    end

    it 'delegate to response' do
      allow(response).to receive(:success?).and_return(true)
      expect(subject).to be_success

      allow(response).to receive(:success?).and_return(false)
      expect(subject).not_to be_success
    end
  end

  describe '#serialize' do
    let(:response) do
      double(:HttpResponse, xml?: true, success?: true)
    end

    context 'when request succeeds' do
      it 'not change discount errors' do
        expect { subject.serialize }.not_to change { discount.errors.empty? }
      end
    end

    context 'when request fails' do
      let(:response) do
        double(
          :HttpResponse,
          data: parsed_xml,
          error: Aitch::BadRequestError,
          error?: true,
          success?: false,
          xml?: true
        )
      end

      let(:raw_xml) do
        File.read('./spec/fixtures/subscription_discount/fail.xml')
      end

      let(:parsed_xml) do
        Nokogiri::XML(raw_xml)
      end

      it 'change discount errors' do
        expect { subject.serialize }.to change { discount.errors.empty? }
      end
    end
  end
end
