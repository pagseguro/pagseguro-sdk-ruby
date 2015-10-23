require "spec_helper"

describe PagSeguro::TransactionRequest::ResponseSerializer do
  context "for existing transactions" do
    let(:source) { File.read("./spec/fixtures/transaction_request/success.xml") }
    let(:xml) { Nokogiri::XML(source) }
    let(:serializer) { described_class.new(xml.css("transaction").first) }
    subject(:data) { serializer.serialize }

    it { expect(data).to include(created_at: Time.parse("2011-02-05T15:46:12.000-02:00")) }
    it { expect(data).to include(updated_at: Time.parse("2011-02-15T17:39:14.000-03:00")) }
    it { expect(data).to include(code: "9E884542-81B3-4419-9A75-BCC6FB495EF1") }
    it { expect(data).to include(reference: "REF1234") }
    it { expect(data).to include(type_id: "1") }
    it { expect(data).to include(status: "3") }
    it { expect(data).to include(payment_method: {type_id: "1", code: "101"}) }
    it { expect(data).to include(payment_link: "https://pagseguro.uol.com.br/checkout/imprimeBoleto.jhtml?code=314601B208B24A5CA5
  3260000F7BB0D0") }
    it { expect(data).to include(gross_amount: BigDecimal("49900.00")) }
    it { expect(data).to include(discount_amount: BigDecimal("0.00")) }
    it { expect(data).to include(net_amount: BigDecimal("49900.50")) }
    it { expect(data).to include(extra_amount: BigDecimal("0.00")) }
    it { expect(data).to include(installment_count: 1) }

    it { expect(data[:items].size).to eq(2) }
    it { expect(data[:items].first).to include(id: "0001") }
    it { expect(data[:items].first).to include(description: "Notebook Prata") }
    it { expect(data[:items].first).to include(quantity: 1) }
    it { expect(data[:items].first).to include(amount: BigDecimal("24300.00")) }
    it { expect(data[:items][1]).to include(id: "0002") }
    it { expect(data[:items][1]).to include(description: "Notebook Rosa") }
    it { expect(data[:items][1]).to include(quantity: 1) }
    it { expect(data[:items][1]).to include(amount: BigDecimal("25600.00")) }

    it { expect(data[:sender]).to include(name: "Jose Comprador") }
    it { expect(data[:sender]).to include(email: "comprador@uol.com.br") }
    it { expect(data[:sender][:phone]).to include(area_code: "11") }
    it { expect(data[:sender][:phone]).to include(number: "56273440") }

    it { expect(data[:shipping]).to include(type_id: "1") }
    it { expect(data[:shipping]).to include(cost: BigDecimal("21.50")) }

    it { expect(data[:shipping][:address]).to include(street: "Av. Brig. Faria Lima") }
    it { expect(data[:shipping][:address]).to include(number: "1384") }
    it { expect(data[:shipping][:address]).to include(complement: "5o andar") }
    it { expect(data[:shipping][:address]).to include(district: "Jardim Paulistano") }
    it { expect(data[:shipping][:address]).to include(city: "Sao Paulo") }
    it { expect(data[:shipping][:address]).to include(state: "SP") }
    it { expect(data[:shipping][:address]).to include(country: "BRA") }
    it { expect(data[:shipping][:address]).to include(postal_code: "01452002") }
  end
end
