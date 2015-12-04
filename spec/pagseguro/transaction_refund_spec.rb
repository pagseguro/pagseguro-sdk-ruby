require "spec_helper"

describe PagSeguro::TransactionRefund do
  let(:xml_parsed) { Nokogiri::XML(raw_xml) }

  it_assigns_attribute :transaction_code
  it_assigns_attribute :value

  it "errors must be a instante of PagSeguro::Errors" do
    expect(subject.errors).to be_a(PagSeguro::Errors)
  end

  describe "#register" do
    let(:refund) { PagSeguro::TransactionRefund.new }

    context 'a correct response' do
      before { FakeWeb.register_uri :any, %r[.*?], body: raw_xml }

      let(:raw_xml) { File.read("./spec/fixtures/refund/success.xml") }

      let :response_request do
        double(:ResponseRequest, success?: true, unauthorized?: false, bad_request?: false, data: xml_parsed, body: raw_xml, :xml? => true)
      end

      it "performs request" do
        expect(PagSeguro::Request).to receive(:post)
          .with("transactions/refunds", "v2", {})
          .and_return(response_request)

        refund.register
      end

      it "returns a PagSeguro::TransactionRefund" do
        expect(refund.register).to be_a(PagSeguro::TransactionRefund)
      end
    end

    context "a failure response" do
      before do
        allow(PagSeguro::Request).to receive(:post)
          .and_return(response_request)
      end

      let(:raw_xml) { File.read("./spec/fixtures/invalid_code.xml") }

      let :response_request do
        double(
          :ResponseRequest,
          success?: false,
          error?: true,
          error: Aitch::ForbiddenError,
          xml?: true,
          data: xml_parsed,
          body: raw_xml
        )
      end

      it "returns a PagSeguro::TransactionRefund with errors" do
        expect(refund.register.errors).not_to be_empty
      end
    end
  end

  it '#update_attributes' do
    refund = PagSeguro::TransactionRefund.new

    expect(refund).to receive(:result=).with("OK")

    refund.update_attributes(result: "OK")
  end
end
