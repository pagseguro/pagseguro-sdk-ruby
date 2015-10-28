# -*- encoding: utf-8 -*-
require "spec_helper"

shared_examples_for "type mapping" do |id, type|
  it "returns #{type.inspect} as type when id is #{id}" do
    expect(PagSeguro::PaymentMethod.new(type_id: id).type).to eql(type)
  end
end

describe PagSeguro::PaymentMethod do
  context "type mapping" do
    it_behaves_like "type mapping", nil, :not_set
    it_behaves_like "type mapping", 1, :credit_card
    it_behaves_like "type mapping", 2, :boleto
    it_behaves_like "type mapping", 3, :online_transfer
    it_behaves_like "type mapping", 4, :balance
    it_behaves_like "type mapping", 5, :oi_paggo
    it_behaves_like "type mapping", 7, :direct_deposit

    it "raises for invalid id" do
      expect {
        PagSeguro::PaymentMethod.new(type_id: "invalid").type
      }.to raise_exception("PagSeguro::PaymentMethod#type_id isn't mapped")
    end
  end

  context "shortcuts" do
    it { expect(PagSeguro::PaymentMethod.new(type_id: 1)).to be_credit_card }
    it { expect(PagSeguro::PaymentMethod.new(type_id: 2)).to be_boleto }
    it { expect(PagSeguro::PaymentMethod.new(type_id: 3)).to be_online_transfer }
    it { expect(PagSeguro::PaymentMethod.new(type_id: 4)).to be_balance }
    it { expect(PagSeguro::PaymentMethod.new(type_id: 5)).to be_oi_paggo }
    it { expect(PagSeguro::PaymentMethod.new(type_id: 7)).to be_direct_deposit }

    it { expect(PagSeguro::PaymentMethod.new(type_id: 5)).not_to be_credit_card }
  end

  context "description" do
    subject(:payment_method) { PagSeguro::PaymentMethod.new(code: 102) }
    it { expect(payment_method.description).to eql("Cartão de crédito MasterCard") }
  end
end
