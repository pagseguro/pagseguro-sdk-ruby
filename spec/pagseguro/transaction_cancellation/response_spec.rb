require "spec_helper"

describe PagSeguro::TransactionCancellation::Response do
  context "when refund is created" do
    # TODO: use helper when merge with 2.2.0 branch
    def xml_response(path)
      response = double(
        body: File.read("./spec/fixtures/#{path}"),
        code: 200,
        content_type: "text/xml",
        "[]" => nil
      )

      Aitch::Response.new({xml_parser: Aitch::XMLParser}, response)
    end

    let(:http_response) { xml_response("transaction_cancellation/success.xml") }
    subject(:response) { described_class.new(http_response) }

    it { expect(response.result).to eq("OK") }
  end
end

