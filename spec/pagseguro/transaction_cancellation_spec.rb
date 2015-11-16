require "spec_helper"

describe PagSeguro::TransactionCancellation do
  let(:xml_parsed) { Nokogiri::XML(raw_xml) }

  it_assigns_attribute :transaction_code

  describe "#register" do
    subject { PagSeguro::TransactionCancellation.new }
    let :http_request do
      double(:ResponseRequest, success?: true, unauthorized?: false, bad_request?: false, data: xml_parsed, body: raw_xml, :xml? => true)
    end

    before do
      allow(PagSeguro::Request).to receive(:post)
        .with("transactions/cancels", "v2", {})
        .and_return(http_request)
    end

    context "when request succeds" do
      let(:raw_xml) { File.read("./spec/fixtures/transaction_cancellation/success.xml") }

      it "returns boolean" do
        expect(subject.register).to be_truthy
      end

      it "does not add errors" do
        expect { subject.register }.not_to change { subject.errors.empty? }
      end

      it "updates attributes" do
        expect { subject.register }.to change { subject.result }
      end
    end

    context "when request fails" do
      before do
        allow(http_request).to receive(:success?).and_return(false)
        allow(http_request).to receive(:bad_request?).and_return(true)
        allow(http_request).to receive(:not_found?).and_return(false)
      end

      let(:raw_xml) { File.read("./spec/fixtures/invalid_code.xml") }

      it "adds errors" do
        expect { subject.register }.to change { subject.errors.empty? }
      end
    end
  end

  it '#update_attributes' do
    cancellation = PagSeguro::TransactionCancellation.new

    expect(cancellation).to receive(:result=).with("OK")

    cancellation.update_attributes(result: "OK")
  end
end
