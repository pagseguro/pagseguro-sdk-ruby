# -*- encoding: utf-8 -*-
require "spec_helper"

describe PagSeguro::Transaction::Serializer do
  context "for existing transactions" do
    let(:source) { File.read("./spec/fixtures/transactions/success.xml") }
    let(:xml) { Nokogiri::XML(source) }
    let(:serializer) { described_class.new(xml.css("transaction").first) }
    subject(:data) { serializer.serialize }

    it { expect(data).to include(created_at: Time.parse("2013-05-01T01:40:27.000-03:00")) }
    it { expect(data).to include(updated_at: Time.parse("2013-05-01T01:41:20.000-03:00")) }
    it { expect(data).to include(code: "667A3914-4F9F-4705-0EB6-CA6FA0DF8A19") }
    it { expect(data).to include(reference: "REF1234") }
    it { expect(data).to include(type_id: "1") }
    it { expect(data).to include(status: "1") }
    it { expect(data).to include(payment_method: {type_id: "2", code: "202"}) }
    it { expect(data).to include(payment_link: "https://pagseguro.uol.com.br/checkout/imprimeBoleto.jhtml?code=667D39144F9F47059FB6CA6FA0DF8A20") }
    it { expect(data).to include(gross_amount: BigDecimal("459.50")) }
    it { expect(data).to include(discount_amount: BigDecimal("0.00")) }
    it { expect(data).to include(net_amount: BigDecimal("445.77")) }
    it { expect(data).to include(extra_amount: BigDecimal("0.00")) }
    it { expect(data).to include(installments: 1) }

    it { expect(data.keys).not_to include(:cancellation_source) }
    it { expect(data.keys).not_to include(:escrow_end_date) }

    it { expect(data[:creditor_fees]).to include(intermediation_rate_amount: BigDecimal("0.40")) }
    it { expect(data[:creditor_fees]).to include(intermediation_fee_amount: BigDecimal("1644.80")) }
    it { expect(data[:creditor_fees]).to include(installment_fee_amount: BigDecimal("0.00")) }
    it { expect(data[:creditor_fees]).to include(operational_fee_amount: BigDecimal("0.00")) }
    it { expect(data[:creditor_fees]).to include(commission_fee_amount: BigDecimal("1.98")) }
    it { expect(data[:creditor_fees]).to include(efrete: BigDecimal("1.98")) }

    it { expect(data[:payment_releases].size).to eq(1) }
    it { expect(data[:payment_releases].first).to include(installment: "1") }
    it { expect(data[:payment_releases].first).to include(total_amount: BigDecimal("202.92")) }
    it { expect(data[:payment_releases].first).to include(release_amount: BigDecimal("202.92")) }
    it { expect(data[:payment_releases].first).to include(status: "OPENED") }
    it { expect(data[:payment_releases].first).to include(release_date: Time.parse("2015-03-25T16:14:23-03:00")) }

    it { expect(data[:items].size).to eq(1) }
    it { expect(data[:items].first).to include(id: "1234") }
    it { expect(data[:items].first).to include(description: "Some product") }
    it { expect(data[:items].first).to include(quantity: 1) }
    it { expect(data[:items].first).to include(amount: BigDecimal("459.50")) }

    it { expect(data[:sender]).to include(name: "JOHN DOE") }
    it { expect(data[:sender]).to include(email: "john@example.com") }
    it { expect(data[:sender][:phone]).to include(area_code: "11") }
    it { expect(data[:sender][:phone]).to include(number: "12345678") }
    it { expect(data[:sender][:document]).to include(type: "CPF") }
    it { expect(data[:sender][:document]).to include(value: "65647162142") }

    it { expect(data[:shipping]).to include(type_id: "2") }

    it { expect(data[:shipping][:address]).to include(street: "AV. BRIG. FARIA LIMA") }
    it { expect(data[:shipping][:address]).to include(number: "1384") }
    it { expect(data[:shipping][:address]).to include(complement: "5 ANDAR") }
    it { expect(data[:shipping][:address]).to include(district: "JARDIM PAULISTANO") }
    it { expect(data[:shipping][:address]).to include(city: "SAO PAULO") }
    it { expect(data[:shipping][:address]).to include(state: "SP") }
    it { expect(data[:shipping][:address]).to include(country: "BRA") }
    it { expect(data[:shipping][:address]).to include(postal_code: "01452002") }
  end

  context "additional nodes" do
    let(:source) { File.read("./spec/fixtures/transactions/additional.xml") }
    let(:xml) { Nokogiri::XML(source) }
    let(:serializer) { described_class.new(xml) }
    subject(:data) { serializer.serialize }

    it { expect(data).to include(cancellation_source: "PagSeguro") }
    it { expect(data).to include(escrow_end_date: Time.parse("2013-06-01T01:41:20.000-03:00")) }
  end

  context "when looking for transaction status history" do
    let(:source) { File.read("./spec/fixtures/transactions/status_history.xml") }
    let(:xml) { Nokogiri::XML(source) }
    let(:serializer) { described_class.new(xml) }
    subject(:data) { serializer.serialize_status_history }

    it { expect(data.first.code).to eq("1") }
    it { expect(data.first.date).to eq(Time.parse("2015-02-24T10:23:34.000-03:00")) }
    it { expect(data.first.notification_code).to eq("B7C381-7AADE5ADE576-8CC4159F8FBB-25C7D6") }
  end
end
