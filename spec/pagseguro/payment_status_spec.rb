# -*- encoding: utf-8 -*-
require "spec_helper"

shared_examples_for "payment status mapping" do |id, status, description|
  let(:payment_status) { PagSeguro::PaymentStatus.new(id) }

  it "returns #{status} as status when id is #{id}" do
    expect(payment_status.status).to eql(status)
  end

  it "detects as #{status}" do
    expect(payment_status.public_send("#{status}?")).to be
  end

  it "described as #{description}" do
    expect(payment_status.description).to eq(description)
  end
end

describe PagSeguro::PaymentStatus do
  context "status mapping" do
    it_behaves_like "payment status mapping", 0, :initiated, 'Iniciada'
    it_behaves_like "payment status mapping", 1, :waiting_payment, 'Aguardando pagamento'
    it_behaves_like "payment status mapping", 2, :in_analysis, 'Em análise'
    it_behaves_like "payment status mapping", 3, :paid, 'Paga'
    it_behaves_like "payment status mapping", 4, :available, 'Disponível'
    it_behaves_like "payment status mapping", 5, :in_dispute, 'Em disputa'
    it_behaves_like "payment status mapping", 6, :refunded, 'Devolvida'
    it_behaves_like "payment status mapping", 7, :cancelled, 'Cancelada'
    it_behaves_like "payment status mapping", 8, :chargeback_charged, 'Chargeback debitado'
    it_behaves_like "payment status mapping", 9, :contested, 'Em contestação'
  end
end
