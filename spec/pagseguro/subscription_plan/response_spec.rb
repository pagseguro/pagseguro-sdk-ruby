require 'spec_helper'

RSpec.describe PagSeguro::SubscriptionPlan::Response do
  subject { PagSeguro::SubscriptionPlan::Response.new(http_response, plan) }
  let(:plan) { PagSeguro::SubscriptionPlan.new }

  context '#success?' do
    let(:http_response) do
      double(:HttpResponse, xml?: true)
    end

    it 'delegate to response' do
      allow(http_response).to receive(:success?).and_return(true)
      expect(subject).to be_success

      allow(http_response).to receive(:success?).and_return(false)
      expect(subject).not_to be_success
    end
  end

  describe '#serialize' do
    let(:http_response) do
      double(
        :Request,
        success?: true,
        xml?: true,
        data: xml_parsed,
        body: raw_xml,
        unauthorized?: false,
        bad_request?: false,
        not_found?: false
      )
    end

    let(:xml_parsed) { Nokogiri::XML(raw_xml) }

    context 'when request succeeds' do
      let(:raw_xml) { File.read('./spec/fixtures/subscription_plan/success.xml') }

      it 'returns a hash with serialized response data' do
        expect { subject.serialize }.to change { plan.code }
      end

      it 'not change subscription plan errors' do
        expect { subject.serialize }.not_to change { plan.errors.empty? }
      end
    end

    context 'when request fails' do
      before do
        allow(http_response).to receive_messages(
          success?: false,
          error?: true,
          error: Aitch::BadRequestError
        )
      end

      let(:raw_xml) { File.read('./spec/fixtures/subscription_plan/fail.xml') }

      it 'change subscription plan errors' do
        expect { subject.serialize }.to change { plan.errors.empty? }
      end
    end
  end
end
