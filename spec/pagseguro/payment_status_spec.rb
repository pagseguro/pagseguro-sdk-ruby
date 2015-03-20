require "spec_helper"

shared_examples_for "payment status mapping" do |id, status|
  it "returns #{status} as status when id is #{id}" do
    expect(PagSeguro::PaymentStatus.new(id).status).to eql(status)
  end

  it "detects as #{status}" do
    expect(PagSeguro::PaymentStatus.new(id).public_send("#{status}?")).to be
  end
end

describe PagSeguro::PaymentStatus do
  context "status mapping" do
    it_behaves_like "payment status mapping", 0, :initiated
    it_behaves_like "payment status mapping", 1, :waiting_payment
    it_behaves_like "payment status mapping", 2, :in_analysis
    it_behaves_like "payment status mapping", 3, :paid
    it_behaves_like "payment status mapping", 4, :available
    it_behaves_like "payment status mapping", 5, :in_dispute
    it_behaves_like "payment status mapping", 6, :refunded
    it_behaves_like "payment status mapping", 7, :cancelled
    it_behaves_like "payment status mapping", 8, :chargeback_charged
    it_behaves_like "payment status mapping", 9, :contested
  end
end
