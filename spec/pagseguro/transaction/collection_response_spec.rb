require "spec_helper"

describe PagSeguro::Transaction::CollectionResponse do
  let(:collection) { PagSeguro::Transaction::Collection.new }

  subject { PagSeguro::Transaction::CollectionResponse.new(http_response, collection) }

  context "#success?" do
    let(:http_response) do
      double(:HttpResponse, xml?: true)
    end

    it "delegates to response" do
      allow(http_response).to receive(:success?).and_return(true)
      expect(subject).to be_success

      allow(http_response).to receive(:success?).and_return(false)
      expect(subject).not_to be_success
    end
  end

  describe "#serialize" do
    let(:http_response) do
      double(:Response, xml?: true, success?: true, unauthorized?: false,
             bad_request?: false, body: raw_xml, data: parsed_xml)
    end
    let(:parsed_xml) { Nokogiri::XML(raw_xml) }

    context "when request succeeds" do
      let(:raw_xml) { File.read("./spec/fixtures/transactions/status_history.xml") }

      it "returns PagSeguro::Transaction::Collection instance" do
        expect(subject.serialize).to be_a(PagSeguro::Transaction::Collection)
      end

      it "not change errors" do
        expect { subject.serialize }.not_to change { collection.errors.empty? }
      end
    end

    context "when request fails" do
      before do
        allow(http_response).to receive(:success?).and_return(false)
        allow(http_response).to receive(:bad_request?).and_return(true)
        allow(http_response).to receive(:body).and_return(raw_xml)
      end
      let(:raw_xml) { File.read("./spec/fixtures/invalid_code.xml") }

      it "returns PagSeguro::Transaction::Collection instance" do
        expect(subject.serialize).to be_a(PagSeguro::Transaction::Collection)
      end

      it "change collection errors" do
        expect { subject.serialize }.to change { collection.errors.empty? }
      end
    end
  end
end
