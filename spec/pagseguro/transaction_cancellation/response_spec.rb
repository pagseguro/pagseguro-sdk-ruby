require "spec_helper"

describe PagSeguro::TransactionCancellation::Response do
  let(:http_response) do
    response = double(body: "", code: 200, content_type: "text/xml", "[]" => nil)
    Aitch::Response.new({xml_parser: Aitch::XMLParser}, response)
  end
  let(:cancellation) { PagSeguro::TransactionCancellation.new }

  subject { PagSeguro::TransactionCancellation::Response.new(http_response, cancellation) }

  describe "#serialize" do
    context "when request succeeds" do
      let(:raw_xml) { File.read("./spec/fixtures/transaction_cancellation/success.xml") }

      it "returns PagSeguro::TransactionCancellation instance" do
        expect(subject.serialize).to be_a(PagSeguro::TransactionCancellation)
      end

      it "not change cancellation errors" do
        expect { subject.serialize }.not_to change { cancellation.errors.empty? }
      end
    end

    context "when request fails" do
      before do
        allow(http_response).to receive_messages(
          success?: false,
          error?: true,
          error: Aitch::BadRequestError,
          body: raw_xml
        )
      end
      let(:raw_xml) { File.read("./spec/fixtures/invalid_code.xml") }

      it "returns PagSeguro::TransactionCancellation instance" do
        expect(subject.serialize).to be_a(PagSeguro::TransactionCancellation)
      end

      it "change cancellation errors" do
        expect { subject.serialize }.to change { cancellation.errors.empty? }
      end
    end
  end
end
