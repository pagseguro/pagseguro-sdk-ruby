require 'spec_helper'

describe PagSeguro::Authorization do
  let(:code) { "1234" }
  let(:notification_code) { "4321" }
  let(:crendentials) { double(:crendentials) }
  let(:options) { { crendentials: crendentials} }
  let(:request) { double(:request) }
  let(:response) { double(:response) }

  describe ".find_by_notification_code" do
    before do
      expect(PagSeguro::Request).to receive(:get)
        .with("authorizations/notifications/4321", options)
        .and_return(request)
      expect(PagSeguro::Authorization::Response).to receive(:new)
        .with(request)
        .and_return(response)
      expect(response).to receive(:serialize).and_return(PagSeguro::Authorization.new)
    end

    xit "finds authorization by the given notificationCode" do
      authorization = PagSeguro::Authorization.find_by_notification_code(notification_code, options)
      expect(authorization).to be_a(PagSeguro::Authorization)
    end
  end

  describe ".find_by_code" do
    xit "finds authorization by the given notificationCode" do
      PagSeguro::Authorization.stub :load_from_response

      expect(PagSeguro::Request).to receive(:get)
        .with('authorizations/CODE', {})
        .and_return(double.as_null_object)

      PagSeguro::Authorization.find_by_code("CODE")
    end
  end
end
