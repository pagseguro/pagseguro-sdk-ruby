require 'spec_helper'

describe PagSeguro::AuthorizationRequest do
  it_assigns_attribute :permissions
  it_assigns_attribute :reference
  it_assigns_attribute :notification_url
  it_assigns_attribute :redirect_url

  describe "#create" do
    let(:request) { double(:request) }
    let(:response) { double(:response) }
    let(:options) do
      {
        notification_url: "foo",
        redirect_url: "bar",
        permissions: [:notifications, :searches]
      }
    end

    let(:params) do
      {
        notificationURL: "foo",
        redirectURL: "bar",
        permissions: "RECEIVE_TRANSACTION_NOTIFICATIONS,SEARCH_TRANSACTIONS"
      }
    end

    subject { described_class.new(options) }

    before do
      expect(PagSeguro::Request).to receive(:post)
        .with("authorizations/request", 'v2', params)
        .and_return(request)
      expect(PagSeguro::AuthorizationRequest::Response).to receive(:new)
        .with(request)
        .and_return(response)
      expect(response).to receive(:serialize).and_return(serialized_data)
    end

    context "when request succeeds" do
      let(:serialized_data) { {code: "123"} }

      it "creates a transaction request" do
        expect(response).to receive(:success?).and_return(true)

        expect(subject.create).to be_truthy
        expect(subject.code).to eq(serialized_data[:code])
      end
    end

    context "when request fails" do
      let(:serialized_data) { {errors: PagSeguro::Errors.new} }

      it "does not create a transaction request" do
        expect(response).to receive(:success?).and_return(false)

        expect(subject.create).to be_falsey
        expect(subject.code).to be_nil
      end
    end
  end
end
