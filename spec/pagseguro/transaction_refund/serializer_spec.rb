require "spec_helper"

describe PagSeguro::TransactionRefund::Serializer do
  let(:refund) { PagSeguro::TransactionRefund.new }
  let(:params) { serializer.to_params }
  subject(:serializer) { described_class.new(refund) }

  before do
    refund.transaction_code = "1234"
    refund.value = 100.50
  end

  it { expect(params).to include(transactionCode: "1234") }
  it { expect(params).to include(refundValue: "100.50") }
end
