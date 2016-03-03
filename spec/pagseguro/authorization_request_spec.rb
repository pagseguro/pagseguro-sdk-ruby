require 'spec_helper'

describe PagSeguro::AuthorizationRequest do
  it_assigns_attribute :permissions
  it_assigns_attribute :reference
  it_assigns_attribute :notification_url
  it_assigns_attribute :redirect_url

  before(:all) { PagSeguro.configuration.environment = :sandbox }

  let(:credentials) { PagSeguro::ApplicationCredentials.new('APP_ID', 'APP_KEY') }
  let(:api_version) { PagSeguro::AuthorizationRequest::API_VERSION }
  let(:options) do
    {
      credentials: credentials,
      permissions: [:searches, :notifications],
      notification_url: 'http://example.com/',
      redirect_url: 'http://example.com/',
      reference: 'REF4321'
    }
  end

  let(:request) do
    VCR.use_cassette('authorization_request-success') do
      PagSeguro::Request.post_xml('authorizations/request', api_version, credentials, xml)
    end
  end

  let(:response) { PagSeguro::AuthorizationRequest::Response.new(request) }

  let(:authorization_request) do
    PagSeguro::AuthorizationRequest.new(options)
  end

  let(:xml) { PagSeguro::AuthorizationRequest::RequestSerializer.new(authorization_request).build_xml }

  describe "#create" do
    it "when was created successful" do
      VCR.use_cassette('authorization_request-success') do
        expect(authorization_request.create).to be_truthy
      end
    end

    context "when was not created successful" do
      before { credentials = nil }

      around do |example|
        VCR.use_cassette('authorization_request-fail') do
          example.run
        end
      end

      it "should return false" do
        expect(authorization_request.create).to be_falsey
      end

      it "should update errors" do
        expect{ authorization_request.create }.to change{ authorization_request.errors }
      end
    end
  end
end
