require "spec_helper"

describe PagSeguro::Transaction do
  describe ".find_by_code" do
    before { PagSeguro::Transaction.stub :load_from_response }

    it "finds transaction by the given code" do
      PagSeguro::Request
        .should_receive(:get)
        .with("transactions/notifications/CODE")
        .and_return(stub.as_null_object)

      PagSeguro::Transaction.find_by_code("CODE")
    end
  end

  describe "attributes" do
    before do
      body = File.read("./spec/fixtures/transactions/success.xml")
      FakeWeb.register_uri :get, %r[.+], body: body, content_type: "text/xml"
    end

    subject(:transaction) { PagSeguro::Transaction.find_by_code("CODE") }

    it { expect(transaction.sender).to be_a(PagSeguro::Sender) }
    it { expect(transaction.shipping).to be_a(PagSeguro::Shipping) }
    it { expect(transaction.items).to be_a(PagSeguro::Items) }
    it { expect(transaction.payment_method).to be_a(PagSeguro::PaymentMethod) }
    it { expect(transaction.status).to be_a(PagSeguro::PaymentStatus) }
    it { expect(transaction.items).to have(1).item }
  end
end
