require "spec_helper"

describe PagSeguro::Installment::RequestSerializer do
  let(:data) { { amount: "100.00", card_brand: "visa" } }
  let(:params) { serializer.to_params }
  subject(:serializer) { described_class.new(data) }

  it { expect(params).to include(amount: "100.00") }
  it { expect(params).to include(cardBrand: "visa") }

  context "when card brand is not present" do
    let(:data) { { amount: "100.00" } }

    it { expect(params).to_not include(cardBrand: "visa") }
  end
end
