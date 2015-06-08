require "spec_helper"

describe PagSeguro::TransactionCancellation::RequestSerializer do
  subject do
    PagSeguro::TransactionCancellation::RequestSerializer.new(cancellation)
  end

  let(:cancellation) do
    PagSeguro::TransactionCancellation.new transaction_code: "1234"
  end

  it { expect(subject.to_params).to include(transactionCode: "1234") }
end
