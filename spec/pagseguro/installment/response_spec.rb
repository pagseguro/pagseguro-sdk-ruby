require "spec_helper"

RSpec.describe PagSeguro::Installment::Response do
  let(:http_response) do
    double(:request, success?: true, xml?: true, data: xml_parsed,
           body: raw_xml, unauthorized?: false, :not_found? => false)
  end
  let(:xml_parsed) { Nokogiri::XML(raw_xml) }
  let(:collection) { PagSeguro::Installment::Collection.new }
  subject { PagSeguro::Installment::Response.new(http_response, collection) }

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

  describe "#serialize" do
    context "when request succeeds" do
      let(:serializer) { double(:serializer) }
      let(:raw_xml) { File.read("./spec/fixtures/installment/success.xml") }

      it "not change errors" do
        expect { subject.serialize }.not_to change { collection.errors.empty? }
      end

      it "return a collection instance" do
        expect(subject.serialize).to be_a(PagSeguro::Installment::Collection)
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

      it "update collection errors" do
        expect { subject.serialize }.to change { collection.errors.empty? }
      end
    end
  end
end
