require "spec_helper"

RSpec.describe PagSeguro::Session::Response do
  subject { PagSeguro::Session::Response.new(http_response, session) }
  let(:session) { PagSeguro::Session.new }

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
    let(:http_response) do
      double(:request, success?: true, xml?: true, data: xml_parsed,
             body: raw_xml, unauthorized?: false, bad_request?: false,
             not_found?: false)
    end
    let(:xml_parsed) { Nokogiri::XML(raw_xml) }

    context "when request succeeds" do
      let(:raw_xml) { File.read("./spec/fixtures/session/success.xml") }

      it "returns a hash with serialized response data" do
        expect { subject.serialize }.to change { session.id }
      end

      it "not change session errors" do
        expect { subject.serialize }.not_to change { session.errors.empty? }
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

      it "change session errors" do
        expect { subject.serialize }.to change { session.errors.empty? }
      end
    end
  end
end
