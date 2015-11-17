require "spec_helper"

describe PagSeguro::TransactionRefund::RequestSerializer do
  subject(:serializer) { PagSeguro::TransactionRefund::RequestSerializer.new(refund) }

  let(:refund) do
    PagSeguro::TransactionRefund.new transaction_code: "1234",
      value: "100.50"
  end

  let(:params) { serializer.to_params }

  it { expect(params).to include(transactionCode: "1234") }
  it { expect(params).to include(refundValue: "100.50") }
end
