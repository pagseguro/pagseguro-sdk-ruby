require "spec_helper"

describe PagSeguro::Session do |variable|
  describe ".create" do
    subject { PagSeguro::Session }
    let(:request) do
      double(:request, success?: true, xml?: true, data: xml_parsed,
             body: raw_xml, unauthorized?: false, bad_request?: false,
             not_found?: false)
    end
    let(:xml_parsed) { Nokogiri::XML(raw_xml) }
    let(:raw_xml) { File.read("./spec/fixtures/session/success.xml") }

    before do
      allow(PagSeguro::Request).to receive(:post)
        .with("sessions", "v2")
        .and_return(request)
    end

    context "when request succeeds" do
      it "creates a session" do
        expect(subject.create).to be_a(PagSeguro::Session)
      end
    end

    context "when request fails" do
      before do
        allow(request).to receive_messages(
          success?: false,
          error?: true,
          error: Aitch::BadRequestError
        )
      end
      let(:raw_xml) { File.read("./spec/fixtures/invalid_code.xml") }

      it "create a session" do
        expect(subject.create).to be_a(PagSeguro::Session)
      end

      it "create a session with errors" do
        expect(subject.create.errors).not_to be_empty
      end
    end
  end
end
