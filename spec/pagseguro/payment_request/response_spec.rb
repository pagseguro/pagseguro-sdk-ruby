require "spec_helper"

describe PagSeguro::PaymentRequest::Response do
  context "when payment request is created" do
    def xml_response(path)
      response = double(
        body: File.read("./spec/fixtures/#{path}"),
        code: 200,
        content_type: "text/xml",
        "[]" => nil
      )

      Aitch::Response.new({xml_parser: Aitch::XMLParser}, response)
    end

    let(:http_response) { xml_response("payment_request/success.xml") }
    subject(:response) { described_class.new(http_response) }

    it { expect(response.code).to eql("8CF4BE7DCECEF0F004A6DFA0A8243412") }
    it { expect(response.created_at).to eql(Time.parse("2010-12-02T10:11:28.000-02:00")) }
    it { expect(response.url).to eql("https://pagseguro.uol.com.br/v2/checkout/payment.html?code=8CF4BE7DCECEF0F004A6DFA0A8243412") }
  end
end

