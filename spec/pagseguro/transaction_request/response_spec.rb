require "spec_helper"

describe PagSeguro::TransactionRequest::Response do
  context "when transaction request is created" do
    let(:http_response) { xml_response("transaction_request/success.xml") }
    subject(:response) { described_class.new(http_response) }

    it { expect(response.code).to eq("9E884542-81B3-4419-9A75-BCC6FB495EF1") }
    it { expect(response.created_at).to eq(Time.parse("2011-02-05T15:46:12.000-02:00")) }
    it { expect(response.payment_link).to eq("https://pagseguro.uol.com.br/checkout/imprimeBoleto.jhtml?code=314601B208B24A5CA5
  3260000F7BB0D0") }
  end
end
