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
    before do
      load "./lib/pagseguro.rb"
    end

    it { expect(PagSeguro.encoding).to eql("UTF-8") }
    it { expect(PagSeguro.endpoint).to eql("https://ws.pagseguro.uol.com.br/v2") }
    it { expect(PagSeguro.environment).to eql("production") }
  end
end
