require "spec_helper"

describe PagSeguro::TransactionCancellation::Serializer do
  let(:cancellation) { PagSeguro::TransactionCancellation.new }
  let(:params) { serializer.to_params }
  subject(:serializer) { described_class.new(cancellation) }

  before do
    cancellation.transaction_code = "1234"
  end

  it { expect(params).to include(transactionCode: "1234") }
end
