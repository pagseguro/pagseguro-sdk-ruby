require "spec_helper"

describe PagSeguro::Installment do
  it_assigns_attribute :card_brand
  it_assigns_attribute :quantity
  it_assigns_attribute :amount
  it_assigns_attribute :total_amount
  it_assigns_attribute :interest_free

  let(:request) do
    double(:request, success?: true, xml?: true, body: raw_xml, data: xml_parsed, unauthorized?: false, not_found?: false)
  end

  let(:xml_parsed) { Nokogiri::XML(raw_xml) }

  describe ".find" do
    subject { PagSeguro::Installment }
    let(:params) { { amount: "100.00", cardBrand: "visa" } }

    before do
      allow(PagSeguro::Request).to receive(:get)
        .with("installments", "v2", params)
        .and_return(request)
    end

    context "when request succeeds" do
      let(:raw_xml) { File.read("./spec/fixtures/installment/success.xml") }

      it "returns a instance of collection" do
        expect(subject.find("100.00", "visa")).to be_a(PagSeguro::Installment::Collection)
      end
    end

    context "when request fails" do
      before do
        allow(request).to receive_messages(
          success?: false,
          error?: true,
          error: Aitch::BadRequestError
        )
      end

      let(:raw_xml) { File.read("./spec/fixtures/invalid_code.xml") }

      it "returns collection with error" do
        expect(subject.find("100.00", "visa").errors).not_to be_empty
      end
    end
  end
end
