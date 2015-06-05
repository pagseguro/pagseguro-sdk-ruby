require "spec_helper"

describe PagSeguro::Refund::RequestSerializer do
  subject(:serializer) { PagSeguro::Refund::RequestSerializer.new(refund) }

  let(:refund) do
    PagSeguro::Refund.new transaction_code: "1234",
      value: "100.50"
  end

  let(:params) { serializer.to_params }

  it { expect(params).to include(transactionCode: "1234") }
  it { expect(params).to include(refundValue: "100.50") }
end
