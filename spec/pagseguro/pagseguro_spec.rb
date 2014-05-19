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

  context "configuring library" do
    it "yields PagSeguro" do
      expect {|block|
        PagSeguro.configure(&block)
      }.to yield_with_args(PagSeguro)
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

    context 'when environment is production' do
      it "returns api url" do
        expect(PagSeguro.api_url("/some/path")).to eql("https://ws.pagseguro.uol.com.br/v2/some/path")
      end
    end

    context 'when environment is sandbox' do
      before do
        PagSeguro.environment = :sandbox
      end

      it "returns sandbox's api url" do
        expect(PagSeguro.api_url("/some/path")).to eql("https://ws.sandbox.pagseguro.uol.com.br/v2/some/path")
      end
    end
  end

  describe ".site_url" do
    it "raises when environment has no endpoint" do
      PagSeguro.environment = :invalid

      expect {
        PagSeguro.site_url("/")
      }.to raise_exception(PagSeguro::InvalidEnvironmentError)
    end

    context 'when environment is production' do
      it "returns site url" do
        expect(PagSeguro.site_url("/some/path")).to eql("https://pagseguro.uol.com.br/v2/some/path")
      end
    end

    context 'when environment is sandbox' do
      before do
        PagSeguro.environment = :sandbox
      end

      it "returns sandbox's site url" do
        expect(PagSeguro.site_url("/some/path")).to eql("https://sandbox.pagseguro.uol.com.br/v2/some/path")
      end
    end
  end
end
