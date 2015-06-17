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

  describe "find_by_date" do
    let(:date_options) { { initial_date: Date.today, final_date: Date.today + 1 } }
    before do
      expect(PagSeguro::Request).to receive(:get)
        .with("authorizations", 'v2', {})
        .and_return(request)
      expect(PagSeguro::Authorization::Collection).to receive(:new)
        .and_return(collection)
      expect(PagSeguro::Authorization::Response).to receive(:new)
        .with(request, collection)
        .and_return(response)
      expect(response).to receive(:serialize_collection)
    end

    it 'finds authorizations by a date range' do
      expect(PagSeguro::Authorization.find_by_date(date_options)).to eq (collection)
    end
  end
end
