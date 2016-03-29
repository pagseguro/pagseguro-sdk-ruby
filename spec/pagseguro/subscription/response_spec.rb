require 'spec_helper'

describe PagSeguro::Subscription::Response do
  subject { PagSeguro::Subscription::Response.new(http_response, subscription) }
  let(:subscription) { PagSeguro::Subscription.new }

  context '#success?' do
    let(:http_response) { double(:HttpResponse, xml?: true) }

    it 'delegate to response' do
      allow(http_response).to receive(:success?).and_return(true)
      expect(subject).to be_success

      allow(http_response).to receive(:success?).and_return(false)
      expect(subject).not_to be_success
    end
  end

  context '#serialize' do
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


      context 'and response is normal' do
        let(:raw_xml) { File.read('./spec/fixtures/subscription/success.xml') }

        it 'not change subscription errors' do
          expect { subject.serialize }.not_to change { subscription.errors.empty? }
        end

        it 'returns a hash with serialized response data' do
          expect{ subject.serialize }.to change { subscription.code }
        end
      end

      context 'and response is a search' do
        let(:raw_xml) { File.read('./spec/fixtures/subscription/search_success.xml') }

        it 'not change subscription errors' do
          expect { subject.serialize }.not_to change { subscription.errors.empty? }
        end

        it 'return a hash with serialized search response data' do
          expect{ subject.serialize(:search) }.to change { subscription.name }
        end
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

      let(:raw_xml) { File.read('./spec/fixtures/subscription/fail.xml') }

      it 'errors should be present' do
        expect { subject.serialize }.to change { subscription.errors }
      end
    end
  end
end
