require 'spec_helper'

describe PagSeguro::Authorization do
  let(:code) { "1234" }
  let(:notification_code) { "4321" }
  let(:crendentials) { double(:crendentials) }
  let(:options) { { crendentials: crendentials} }
  let(:request) { double(:request) }
  let(:response) { double(:response) }
  let(:serialized_data) { { code: 1234 } }
  let(:authorization) { double(:authorization) }
  let(:collection) { double(:collection) }

  describe ".find_by_notification_code" do
    before do
      expect(PagSeguro::Request).to receive(:get)
        .with("authorizations/notifications/4321", 'v2', options)
        .and_return(request)
      expect(PagSeguro::Authorization).to receive(:new)
        .and_return(authorization)
      expect(PagSeguro::Authorization::Response).to receive(:new)
        .with(request, authorization)
        .and_return(response)
      expect(response).to receive(:serialize)
    end

    it "finds authorization by the given notificationCode" do
      expect(PagSeguro::Authorization.find_by_notification_code(notification_code, options))
        .to eq(authorization)
    end
  end

  describe ".find_by_code" do
    before do
      expect(PagSeguro::Request).to receive(:get)
        .with("authorizations/1234", 'v2', options)
        .and_return(request)
      expect(PagSeguro::Authorization).to receive(:new)
        .and_return(authorization)
      expect(PagSeguro::Authorization::Response).to receive(:new)
        .with(request, authorization)
        .and_return(response)
      expect(response).to receive(:serialize)
    end

    it "finds authorization by the given notificationCode" do
      expect(PagSeguro::Authorization.find_by_code(code, options)).to eq(authorization)
    end
  end

  describe "find_by" do
    before do
      allow(PagSeguro::Authorization::Collection).to receive(:new)
        .and_return(collection)
      allow(PagSeguro::Authorization::Response).to receive(:new)
        .with(request, collection)
        .and_return(response)
      allow(response).to receive(:serialize_collection)
    end

    context "with reference" do
      let(:reference) { 'REF1111' }

      it 'finds authorizations' do
        expect(PagSeguro::Request).to receive(:get)
          .with("authorizations", 'v2', { reference: 'REF1111' })
          .and_return(request)

        PagSeguro::Authorization.find_by(reference: 'REF1111')
      end
    end

    context "with initial_date" do
      let(:initial_date) { Time.new(2015, 11, 1, 12, 0) }

      it 'finds authorizations' do
        expect(PagSeguro::Request).to receive(:get)
          .with("authorizations", 'v2', { initialDate: initial_date.xmlschema })
          .and_return(request)

        PagSeguro::Authorization.find_by(initial_date: initial_date)
      end
    end

    context "with final_date" do
      let(:final_date) { Time.new(2015, 11, 1, 12, 0) }

      it 'finds authorizations' do
        expect(PagSeguro::Request).to receive(:get)
          .with("authorizations", 'v2', { finalDate: final_date.xmlschema })
          .and_return(request)

        PagSeguro::Authorization.find_by(final_date: final_date)
      end
    end

    context "with credentials" do
      let(:credentials) do
        PagSeguro::ApplicationCredentials.new('APP_ID', 'APP_KEY')
      end

      it 'passes' do
        expect(PagSeguro::Request).to receive(:get)
          .with("authorizations", 'v2', { credentials: credentials })
          .and_return(request)

        PagSeguro::Authorization.find_by(credentials: credentials)
      end
    end
  end
end
