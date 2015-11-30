require "spec_helper"

describe PagSeguro::Transaction::Response do
  subject { PagSeguro::Transaction::Response.new(http_response, object) }

  context "#success?" do
    let(:object) { double(:Object) }
    let(:http_response) { double(:HttpResponse, xml?: true) }

    it "delegates to response" do
      allow(http_response).to receive(:success?).and_return(true)
      expect(subject).to be_success

      allow(http_response).to receive(:success?).and_return(false)
      expect(subject).not_to be_success
    end
  end

  describe "#serialize_statuses" do
    let(:object) { PagSeguro::Transaction::StatusCollection.new }
    let(:http_response) do
      double(:Response, xml?: true, success?: true, unauthorized?: false,
             bad_request?: false, body: raw_xml, data: parsed_xml)
    end
    let(:parsed_xml) { Nokogiri::XML(raw_xml) }

    context "when request succeeds" do
      let(:raw_xml) { File.read("./spec/fixtures/transactions/status_history.xml") }

      it "returns a collection" do
        expect(subject.serialize_statuses).to be_a(PagSeguro::Transaction::StatusCollection)
      end

      it "not change errors" do
        expect { subject.serialize_statuses }.not_to change { object.errors.empty? }
      end
    end

    context "when request fails" do
      before do
        allow(http_response).to receive_messages(
          success?: false,
          error?: true,
          error: Aitch::NotFoundError,
          body: raw_xml
        )
      end

      let(:raw_xml) { File.read("./spec/fixtures/invalid_code.xml") }

      it "returns PagSeguro::Transaction::StatusCollection instance" do
        expect(subject.serialize_statuses).to be_a(PagSeguro::Transaction::StatusCollection)
      end

      it "change collection errors" do
        expect { subject.serialize_statuses }.to change { object.errors.empty? }
      end
    end
  end

  describe "#serialize" do
    let(:object) { PagSeguro::Transaction.new }
    let(:http_response) do
      double(:Response, xml?: true, success?: true, unauthorized?: false,
             bad_request?: false, body: raw_xml, data: parsed_xml)
    end
    let(:parsed_xml) { Nokogiri::XML(raw_xml) }

    context "when request succeeds" do
      let(:raw_xml) { File.read("./spec/fixtures/transactions/success.xml") }

      it "returns a transaction" do
        expect(subject.serialize).to be_a(PagSeguro::Transaction)
      end

      it "not change errors" do
        expect { subject.serialize }.not_to change { object.errors.empty? }
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

      it "returns the transaction" do
        expect(subject.serialize).to be_a(PagSeguro::Transaction)
      end

      it "change transaction errors" do
        expect { subject.serialize }.to change { object.errors.empty? }
      end
    end
  end
end
