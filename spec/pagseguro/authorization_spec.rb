require 'spec_helper'

describe PagSeguro::Authorization do
  let(:code) { "1234" }
  let(:notification_code) { "4321" }
  let(:crendentials) { double(:crendentials) }
  let(:options) { { crendentials: crendentials} }
  let(:request) { double(:request) }
  let(:response) { double(:response) }
  let(:serialized_data) { { code: 1234 } }

  describe ".find_by_notification_code" do
    before do
      expect(PagSeguro::Request).to receive(:get)
        .with("authorizations/notifications/4321", options)
        .and_return(request)
      expect(PagSeguro::Authorization::Response).to receive(:new)
        .with(request)
        .and_return(response)
      expect(response).to receive(:serialize).and_return(serialized_data)
    end

    it "finds authorization by the given notificationCode" do
      expect(PagSeguro::Authorization).to receive(:new).with(serialized_data)

      PagSeguro::Authorization.find_by_notification_code(notification_code, options)
    end
  end

  describe ".find_by_code" do
    before do
      expect(PagSeguro::Request).to receive(:get)
        .with("authorizations/1234", options)
        .and_return(request)
      expect(PagSeguro::Authorization::Response).to receive(:new)
        .with(request)
        .and_return(response)
      expect(response).to receive(:serialize).and_return(serialized_data)
    end

    it "finds authorization by the given notificationCode" do
      expect(PagSeguro::Authorization).to receive(:new).with(serialized_data)

      PagSeguro::Authorization.find_by_code(code, options)
    end
  end
end
