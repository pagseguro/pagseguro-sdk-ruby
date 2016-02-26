require "spec_helper"

describe PagSeguro::AuthorizationRequest::Response do
  before(:all) do
    PagSeguro.configuration.environment = :sandbox
  end

  let(:options) do
    {
      credentials: credentials,
      permissions: [:searches, :notifications],
      notification_url: 'http://example.com/',
      redirect_url: 'http://example.com/',
      reference: 'REF4321'
    }
  end

  let(:credentials) do
    PagSeguro::ApplicationCredentials.new('APP_ID', 'APP_KEY')
  end

  let(:authorization_request) do
    PagSeguro::AuthorizationRequest.new(options)
  end

  let(:xml) do
    PagSeguro::AuthorizationRequest::RequestSerializer.new(authorization_request).build_xml
  end

  let(:api_version) do
    PagSeguro::AuthorizationRequest::API_VERSION
  end

  subject do
    PagSeguro::AuthorizationRequest::Response.new(request)
  end

  describe "#serialize" do
    let(:request) do
      VCR.use_cassette('authorization_request-response-success') do
        PagSeguro::Request.post_xml('authorizations/request', api_version, credentials, xml)
      end
    end

    context "when request succeeds" do
      it "success should responds true" do
        expect(subject).to be_success
      end

      it "returns a hash" do
        expect(subject.serialize).to be_a Hash
      end

      it "should not be empty" do
        expect(subject.serialize).to_not be_empty
      end

      it "should not have errors" do
        expect(subject.serialize).to_not have_key(:errors)
      end
    end

    context "when request fails" do
      before do
        options[:permissions] = nil
      end

      let(:request) do
        VCR.use_cassette('authorization_request-response-fail') do
          PagSeguro::Request.post_xml('authorizations/request', api_version, credentials, xml)
        end
      end

      it "returns a hash with an errors object" do
        expect(subject.serialize[:errors]).to be_a PagSeguro::Errors
      end

      it "success? should be false" do
        expect(subject).to_not be_success
      end
    end
  end
end

