require "spec_helper"

describe PagSeguro::TransactionCancellation do
  it_assigns_attribute :transaction_code

  describe "#register" do
    let(:cancellation) { PagSeguro::TransactionCancellation.new }
    before { FakeWeb.register_uri :any, %r[.*?], body: "" }

    it "serializes cancellation" do
      serializer = double(:serializer, to_params: {})

      expect(PagSeguro::TransactionCancellation::Serializer).to receive(:new)
        .with(cancellation)
        .and_return(serializer)

      cancellation.register
    end

    it "performs request" do
      expect(PagSeguro::Request).to receive(:post)
        .with("transactions/cancels", "v2", {})

      cancellation.register
    end

    it "initializes response" do
      response = double(:response)
      allow(PagSeguro::Request).to receive(:post).and_return(response)

      expect(PagSeguro::TransactionCancellation::Response).to receive(:new)
        .with(response)

      cancellation.register
    end

    it "returns response" do
      response = double(:response)
      allow(PagSeguro::TransactionCancellation::Response).to receive(:new)
        .and_return(response)

      expect(cancellation.register).to eq(response)
    end
  end
end
