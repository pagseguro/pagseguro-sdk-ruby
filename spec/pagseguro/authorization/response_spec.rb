require "spec_helper"

describe PagSeguro::Authorization::Response do
  let(:xml) { File.read("./spec/fixtures/authorization/find_authorization.xml") }
  let(:http_response) do
    response = double(body: xml, code: 200, content_type: "text/xml", "[]" => nil)
    Aitch::Response.new({xml_parser: Aitch::XMLParser}, response)
  end


  describe "#serialize" do
    subject { described_class.new(http_response, authorization) }
    let(:authorization) { PagSeguro::Authorization.new }

    context "when request succeeds" do
      let(:serializer) { double(:serializer) }
      let(:serialized_data) { { code: "1234"} }

      it "returns a hash with serialized response data" do
        expect(subject.serialize).to eq(authorization)
      end
    end

    context "when request fails" do
      before do
        expect(http_response).to receive(:success?).and_return(false)
      end

      it "returns a hash with an errors object" do
        expect(subject.serialize.errors).to be_a(PagSeguro::Errors)
      end
    end
  end
end

