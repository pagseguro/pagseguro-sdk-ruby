require "spec_helper"

describe PagSeguro::Refund do
  it_assigns_attribute :transaction_code
  it_assigns_attribute :value

  describe "#register" do
    let(:refund) { PagSeguro::Refund.new }
    before { FakeWeb.register_uri :any, %r[.*?], body: "" }

    it "serializes refund" do
      serializer = double(:serializer, to_params: {})

      expect(PagSeguro::Refund::Serializer).to receive(:new)
        .with(refund)
        .and_return(serializer)

      refund.register
    end

    it "performs request" do
      expect(PagSeguro::Request).to receive(:post)
        .with("transactions/refunds", "v2", {})

      refund.register
    end

    it "initializes response" do
      response = double(:response)
      allow(PagSeguro::Request).to receive(:post).and_return(response)

      expect(PagSeguro::Refund::Response).to receive(:new)
        .with(response)

      refund.register
    end

    it "returns response" do
      response = double(:response)
      allow(PagSeguro::Refund::Response).to receive(:new)
        .and_return(response)

      expect(refund.register).to eq(response)
    end
  end
end
