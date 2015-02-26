require "spec_helper"

describe PagSeguro do
  before do
    PagSeguro.email = "EMAIL"
    PagSeguro.token = "TOKEN"
    PagSeguro.receiver_email = "RECEIVER_EMAIL"
  end

  it { expect(PagSeguro.email).to eql("EMAIL") }
  it { expect(PagSeguro.token).to eql("TOKEN") }
  it { expect(PagSeguro.receiver_email).to eql("RECEIVER_EMAIL") }

  context "config delegation" do
    subject { PagSeguro }
    it_behaves_like "a configuration"
  end

  context "configuring library" do
    it "yields PagSeguro" do
      expect {|block|
        PagSeguro.configure(&block)
      }.to yield_with_args(PagSeguro::Config)
    end

    it "is threadsafe" do
      thread = Thread.new do
        PagSeguro.configure do |config|
          config.receiver_email = 'ANOTHER_RECEIVER_EMAIL'
        end
      end
      thread.join

      expect(PagSeguro.receiver_email).to eql("RECEIVER_EMAIL")
    end
  end

  context "default settings" do
    it { expect(PagSeguro.encoding).to eql("UTF-8") }
    it { expect(PagSeguro.environment).to eql(:production) }
  end

  describe ".api_url" do
    it "raises when environment has no endpoint" do
      PagSeguro.environment = :invalid

      expect {
        PagSeguro.api_url("/")
      }.to raise_exception(PagSeguro::InvalidEnvironmentError)
    end

    it "returns production api url when the environment is :production" do
      expect(PagSeguro.api_url("v2/some/path")).to eql("https://ws.pagseguro.uol.com.br/v2/some/path")
    end

    it "returns sandbox api url when the environment is :sandbox" do
      PagSeguro.environment = :sandbox

      expect(PagSeguro.api_url("v2/some/path")).to eql("https://ws.sandbox.pagseguro.uol.com.br/v2/some/path")
    end

  end

  describe ".site_url" do
    it "raises when environment has no endpoint" do
      PagSeguro.environment = :invalid

      expect {
        PagSeguro.site_url("/")
      }.to raise_exception(PagSeguro::InvalidEnvironmentError)
    end

    it "returns production site url when the environment is production" do
      expect(PagSeguro.site_url("v2/some/path")).to eql("https://pagseguro.uol.com.br/v2/some/path")
    end

    it "returns sandbox site url when the environment is :sandbox" do
      PagSeguro.environment = :sandbox
      expect(PagSeguro.site_url("v2/some/path")).to eql("https://sandbox.pagseguro.uol.com.br/v2/some/path")
    end
  end
end
