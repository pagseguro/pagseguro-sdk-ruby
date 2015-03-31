require "spec_helper"

describe PagSeguro::Authorization::Response do
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

    let(:http_response) { xml_response("authorization/success.xml") }
    subject(:response) { described_class.new(http_response) }

    it { expect(response.code).to eql("D8DD848AC9C98D9EE44C5FB3A1E53913") }
    it { expect(response.created_at).to eql(Time.parse("2011-02-25T11:40:50.000-03:00")) }
  end
end

