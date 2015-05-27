require "spec_helper"

describe PagSeguro::AuthorizationRequest::Response do
  let(:http_response) do
    response = double(body: "", code: 200, content_type: "text/xml", "[]" => nil)
    Aitch::Response.new({xml_parser: Aitch::XMLParser}, response)
  end

  subject { described_class.new(http_response) }

  describe "#serialize" do
    context "when request succeeds" do
      let(:serializer) { double(:serializer) }
      let(:serialized_data) { double(:serialized_data) }

      it "returns a hash with serialized response data" do
        expect(PagSeguro::AuthorizationRequest::ResponseSerializer).to receive(:new)
          .and_return(serializer)
        expect(serializer).to receive(:serialize).and_return(serialized_data)

        expect(subject.serialize).to eq(serialized_data)
      end
    end

    context "when request fails" do
      before do
        expect(http_response).to receive(:success?).and_return(false)
      end

      it "returns a hash with an errors object" do
        expect(subject.serialize[:errors]).to be_a(PagSeguro::Errors)
      end
    end
  end
end

