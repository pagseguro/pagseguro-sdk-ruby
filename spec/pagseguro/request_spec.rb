require "spec_helper"

describe PagSeguro::Request do
  context "default headers" do
    subject(:headers) { PagSeguro::Request.config.default_headers }

    it { should include("lib-description" => "ruby:#{PagSeguro::VERSION}") }
    it { should include("language-engine-description" => "ruby:#{RUBY_VERSION}") }
  end

  context "POST request" do
    before do
      FakeWeb.register_uri :post, %r[.+], body: "BODY"
    end

    it "includes credentials" do
      PagSeguro.configuration.email = "EMAIL"
      PagSeguro.configuration.token = "TOKEN"
      PagSeguro::Request.post("checkout", "v3")

      expect(FakeWeb.last_request.body).to include("email=EMAIL&token=TOKEN")
    end

    it "includes custom credentials" do
      PagSeguro.configuration.email = "EMAIL"
      PagSeguro.configuration.token = "TOKEN"
      PagSeguro::Request.post("checkout", "v3", email: 'foo', token: 'bar')

      expect(FakeWeb.last_request.body).to include("email=foo&token=bar")
    end

    it "includes encoding" do
      PagSeguro::Request.post("checkout", "v3")
      expect(FakeWeb.last_request.body).to include("charset=UTF-8")
    end

    it "include request headers" do
      PagSeguro::Request.post("checkout", "v3")
      request = FakeWeb.last_request

      expect(request["Accept-Charset"]).to eql("UTF-8")
      expect(request["Content-Type"]).to eql("application/x-www-form-urlencoded; charset=UTF-8")
      expect(request["lib-description"]).to be
      expect(request["language-engine-description"]).to be
    end

    context "when POST request with XML data" do
      let(:credentials) { PagSeguro::ApplicationCredentials.new('app123', 'key123') }
      let(:xml) { File.read('./spec/fixtures/authorization_request/authorization_request.xml') }

      before do
        PagSeguro::Request.post_xml('authorizations/request', 'v2', credentials, xml)
      end

      let(:request) { FakeWeb.last_request }

      it 'include request headers' do
        expect(request["Content-Type"]).to eq "application/xml; charset=#{PagSeguro.encoding}"
      end

      it 'include data xml' do
        expect(request.body).to eq xml
      end

      it 'correct url' do
        expect(request.path).to eq '/v2/authorizations/request?appId=app123&appKey=key123'
      end
    end
  end

  context "GET request" do
    before do
      FakeWeb.register_uri :get, %r[.+], body: "BODY"
    end

    context "when global acoount config is set" do
      it "includes account credentials" do
        PagSeguro.configure do |config|
          config.email = "EMAIL"
          config.token = "TOKEN"
        end
        PagSeguro::Request.get("checkout", "v3")

        expect(FakeWeb.last_request.path).to include("email=EMAIL&token=TOKEN")
      end
    end

    context "when global app config is set" do
      it "includes application credentials" do
        PagSeguro.configure do |config|
          config.app_id = "APP123"
          config.app_key = "APPKEY"
        end
        PagSeguro::Request.get("checkout", "v3")

        expect(FakeWeb.last_request.path).to include("appId=APP123&appKey=APPKEY")
      end
    end

    it "includes encoding" do
      PagSeguro::Request.get("checkout", "v3")
      expect(FakeWeb.last_request.path).to include("charset=UTF-8")
    end

    it "include request headers" do
      PagSeguro::Request.get("checkout", "v3")
      request = FakeWeb.last_request

      expect(request["Accept-Charset"]).to eql("UTF-8")
      expect(request["lib-description"]).to be
      expect(request["language-engine-description"]).to be
    end
  end
end
