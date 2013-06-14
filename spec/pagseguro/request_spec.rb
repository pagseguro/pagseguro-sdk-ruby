require "spec_helper"

describe PagSeguro::Request do
  context "default headers" do
    subject(:headers) { PagSeguro::Request.config.default_headers }

    it { should include("lib-description" => "ruby-v.#{PagSeguro::VERSION}") }
    it { should include("language-engine-description" => "ruby:#{RUBY_VERSION}") }
  end

  context "POST request" do
    before do
      FakeWeb.register_uri :post, %r[.+], body: "BODY"
    end

    it "includes credentials" do
      PagSeguro.email = "EMAIL"
      PagSeguro.token = "TOKEN"
      PagSeguro::Request.post("checkout")

      expect(FakeWeb.last_request.body).to include("email=EMAIL&token=TOKEN")
    end

    it "includes encoding" do
      PagSeguro::Request.post("checkout")
      expect(FakeWeb.last_request.body).to include("charset=UTF-8")
    end

    it "include request headers" do
      PagSeguro::Request.post("checkout")
      request = FakeWeb.last_request

      expect(request["Accept-Charset"]).to eql("UTF-8")
      expect(request["Content-Type"]).to eql("application/x-www-form-urlencoded; charset=UTF-8")
      expect(request["lib-description"]).to be
      expect(request["language-engine-description"]).to be
    end
  end

  context "GET request" do
    before do
      FakeWeb.register_uri :get, %r[.+], body: "BODY"
    end

    it "includes credentials" do
      PagSeguro.email = "EMAIL"
      PagSeguro.token = "TOKEN"
      PagSeguro::Request.get("checkout")

      expect(FakeWeb.last_request.path).to include("email=EMAIL&token=TOKEN")
    end

    it "includes encoding" do
      PagSeguro::Request.get("checkout")
      expect(FakeWeb.last_request.path).to include("charset=UTF-8")
    end

    it "include request headers" do
      PagSeguro::Request.get("checkout")
      request = FakeWeb.last_request

      expect(request["Accept-Charset"]).to eql("UTF-8")
      expect(request["lib-description"]).to be
      expect(request["language-engine-description"]).to be
    end
  end
end
