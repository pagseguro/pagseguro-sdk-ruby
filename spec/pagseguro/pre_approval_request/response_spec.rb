require "spec_helper"

describe PagSeguro::PreApprovalRequest::Response do
  context "when pre approval request is created" do
    def xml_response(path)
      response = double(
        body: File.read("./spec/fixtures/#{path}"),
        code: 200,
        content_type: "text/xml",
        "[]" => nil
      )

      Aitch::Response.new({xml_parser: Aitch::XMLParser}, response)
    end

    let(:http_response) { xml_response("pre_approval_request/success.xml") }
    subject(:response) { described_class.new(http_response) }

    it { expect(response.code).to eql("DC2DAC98FBFBDD1554493F94E85FAE05") }
    it { expect(response.created_at).to eql(Time.parse("2014-01-21T00:00:00.000-03:00")) }
    it { expect(response.url).to eql("https://pagseguro.uol.com.br/v2/pre-approvals/request.html?code=DC2DAC98FBFBDD1554493F94E85FAE05") }
  end
end

