require "spec_helper"

describe PagSeguro::Installment::ResponseSerializer do
  context "when there are installments" do
    let(:source) { File.read("./spec/fixtures/installment/success.xml") }
    let(:xml) { Nokogiri::XML(source) }
    subject(:data) do
      xml.css("installments > installment").map do |xml|
        described_class.new(xml).serialize
      end
    end

    it { expect(data.size).to eq(3) }

    it { expect(data[0]).to include(card_brand: "visa") }
    it { expect(data[0]).to include(quantity: "1") }
    it { expect(data[0]).to include(amount: "500.00") }
    it { expect(data[0]).to include(total_amount: "500.00") }
    it { expect(data[0]).to include(interest_free: "true") }

    it { expect(data[1]).to include(card_brand: "visa") }
    it { expect(data[1]).to include(quantity: "2") }
    it { expect(data[1]).to include(amount: "261.28") }
    it { expect(data[1]).to include(total_amount: "522.55") }
    it { expect(data[1]).to include(interest_free: "false") }

    it { expect(data[2]).to include(card_brand: "visa") }
    it { expect(data[2]).to include(quantity: "3") }
    it { expect(data[2]).to include(amount: "176.73") }
    it { expect(data[2]).to include(total_amount: "530.20") }
    it { expect(data[2]).to include(interest_free: "false") }
  end
end
