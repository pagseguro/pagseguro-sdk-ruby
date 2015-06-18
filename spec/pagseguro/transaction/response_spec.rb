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

  describe "#serialize_collection" do
    let(:object) { PagSeguro::Transaction::Collection.new }
    let(:http_response) do
      double(:Response, xml?: true, success?: true, unauthorized?: false,
             bad_request?: false, body: raw_xml, data: parsed_xml)
    end
    let(:parsed_xml) { Nokogiri::XML(raw_xml) }

    context "when request succeeds" do
      let(:raw_xml) { File.read("./spec/fixtures/transactions/status_history.xml") }

      it "returns a collection" do
        expect(subject.serialize_collection).to be_a(PagSeguro::Transaction::Collection)
      end

      it "not change errors" do
        expect { subject.serialize_collection }.not_to change { object.errors.empty? }
      end
    end

    context "when request fails" do
      before do
        allow(http_response).to receive(:success?).and_return(false)
        allow(http_response).to receive(:bad_request?).and_return(true)
        allow(http_response).to receive(:not_found?).and_return(true)
        allow(http_response).to receive(:body).and_return(raw_xml)
      end
      let(:raw_xml) { File.read("./spec/fixtures/invalid_code.xml") }

      it "returns PagSeguro::Transaction::Collection instance" do
        expect(subject.serialize_collection).to be_a(PagSeguro::Transaction::Collection)
      end

      it "change collection errors" do
        expect { subject.serialize_collection }.to change { object.errors.empty? }
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
      let(:raw_xml) { File.read("./spec/fixtures/transactions/status_history.xml") }

      it "returns a transaction" do
        expect(subject.serialize).to be_a(PagSeguro::Transaction)
      end

      it "not change errors" do
        expect { subject.serialize }.not_to change { object.errors.empty? }
      end
    end

    context "when request fails" do
      before do
        allow(http_response).to receive(:success?).and_return(false)
        allow(http_response).to receive(:bad_request?).and_return(true)
        allow(http_response).to receive(:not_found?).and_return(false)
        allow(http_response).to receive(:body).and_return(raw_xml)
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
