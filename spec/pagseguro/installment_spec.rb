require "spec_helper"

describe PagSeguro::Installment do
  it_assigns_attribute :card_brand
  it_assigns_attribute :quantity
  it_assigns_attribute :amount
  it_assigns_attribute :total_amount
  it_assigns_attribute :interest_free

  describe ".find" do
    let(:request_serializer) { double(:request_serializer, to_params: params) }
    let(:params) { { amount: "100.00", card_brand: "visa" } }
    let(:request) { double(:request) }
    let(:response) { double(:response) }

    before do
      expect(PagSeguro::Installment::RequestSerializer).to receive(:new)
        .with(params)
        .and_return(request_serializer)
      expect(PagSeguro::Request).to receive(:get)
        .with("installments", "v2", params)
        .and_return(request)
      expect(PagSeguro::Installment::Response).to receive(:new)
        .with(request)
        .and_return(response)
    end

    context "when request succeeds" do
      let(:serialized_data) { [{amount: "100.00", card_brand: "visa"}] }

      it "finds installments by the given amount" do
        expect(response).to receive(:serialize).and_return(serialized_data)
        expect(PagSeguro::Installment::Collection).to receive(:new)
          .with(serialized_data)

        PagSeguro::Installment.find("100.00", "visa")
      end
    end

    context "when request fails" do
      let(:response) { double(:response, success?: false) }
      let(:serialized_data) { {errors: PagSeguro::Errors.new} }

      it "returns error" do
        expect(response).to receive(:serialize).and_return(serialized_data)
        expect(PagSeguro::Installment::Collection).to receive(:new)
          .with(serialized_data)

        PagSeguro::Installment.find("100.00", "visa")
      end
    end
  end
end
