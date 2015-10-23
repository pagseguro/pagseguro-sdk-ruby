require "spec_helper"

describe PagSeguro::BoletoTransactionRequest do
  describe "#payment_method" do
    it "is boleto" do
      expect(subject.payment_method).to eq("boleto")
    end
  end
end
