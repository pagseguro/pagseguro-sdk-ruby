require "spec_helper"

describe PagSeguro::Refund::Serializer do
  let(:refund) { PagSeguro::Refund.new }
  let(:params) { serializer.to_params }
  subject(:serializer) { described_class.new(refund) }

  before do
    refund.transaction_code = "1234"
  end

  it { expect(params).to include(transactionCode: "1234") }
end
