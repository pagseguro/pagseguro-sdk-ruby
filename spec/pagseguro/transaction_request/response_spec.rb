require "spec_helper"

describe PagSeguro::TransactionRequest::Response do
  let(:transaction_request) do
    PagSeguro::TransactionRequest.new
  end

  subject { PagSeguro::TransactionRequest::Response.new(http_response, transaction_request) }

  context "#success?" do
    let(:http_response) do
      double(:HttpResponse, xml?: true)
    end

    it "delegate to response" do
      allow(http_response).to receive(:success?).and_return(true)
      expect(subject).to be_success

      allow(http_response).to receive(:success?).and_return(false)
      expect(subject).not_to be_success
    end
  end

  context "#serialize" do
    let(:http_response) do
      double(:HttpResponse, data: xml_parsed, body: raw_xml, success?: true, xml?: true, unauthorized?: false, bad_request?: false, not_found?: false)
    end

    let(:xml_parsed) { Nokogiri::XML(raw_xml) }

    context "with success request" do
      let(:raw_xml) { File.read("./spec/fixtures/transaction_request/success.xml") }

      it "return transaction_request instance" do
        expect(subject.serialize).to eq transaction_request
      end

      it "change code" do
        expect { subject.serialize }.to change { transaction_request.code }
      end
    end

    context "when request fails" do
      before do
        allow(http_response).to receive_messages(
          success?: false,
          error?: true,
          error: Aitch::BadRequestError
        )
      end

      let(:raw_xml) { File.read("./spec/fixtures/invalid_code.xml") }

      it "return transaction_request instance" do
        expect(subject.serialize).to eq transaction_request
      end

      it "assign errors" do
        expect { subject.serialize }.to change { transaction_request.errors.empty? }
      end
    end
  end
end
