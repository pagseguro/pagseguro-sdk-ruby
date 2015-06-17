require "spec_helper"

describe PagSeguro::Transaction do
  describe ".find_by_notification_code" do
    it "finds transaction by the given notificationCode" do
      PagSeguro::Transaction.stub :load_from_response

      PagSeguro::Request
        .should_receive(:get)
        .with("transactions/notifications/CODE", "v3")
        .and_return(double.as_null_object)

      PagSeguro::Transaction.find_by_notification_code("CODE")
    end

    it "returns response with errors when request fails" do
      body = %[<?xml version="1.0"?><errors><error><code>1234</code><message>Sample error</message></error></errors>]
      FakeWeb.register_uri :get, %r[.+], status: [400, "Bad Request"], body: body, content_type: "text/xml"
      response = PagSeguro::Transaction.find_by_notification_code("invalid")

      expect(response).to be_a(PagSeguro::Transaction::Response)
      expect(response.errors).to include("Sample error")
    end
  end

  describe ".find_status_history" do
    before do
      allow(PagSeguro::Request).to receive(:get)
        .with("transactions/CODE/statusHistory", "v3")
        .and_return(response)
    end
    let(:parsed_xml) { Nokogiri::XML(raw_xml) }
    let(:response) do
      double(:Response, xml?: true, success?: true, unauthorized?: false,
             bad_request?: false, body: raw_xml, data: parsed_xml)
    end
    subject { PagSeguro::Transaction.find_status_history("CODE") }

    context "when request succeds" do
      let(:raw_xml) { File.read("./spec/fixtures/transactions/status_history.xml") }

      it "returns an instance of Collection" do
        expect(subject).to be_a(PagSeguro::Transaction::Collection)
      end

      it "returns a collection with errors object" do
        expect(subject.errors).to be_a(PagSeguro::Errors)
      end

      it "returns a collection with no errors" do
        expect(subject.errors).to be_empty
      end
    end

    context "when request fails" do
      before do
        allow(response).to receive(:success?).and_return(false)
        allow(response).to receive(:bad_request?).and_return(true)
      end
      let(:raw_xml) { File.read("./spec/fixtures/invalid_code.xml") }

      it "returns an instance of Collection" do
        expect(subject).to be_a(PagSeguro::Transaction::Collection)
      end

      it "returns a collection with errors" do
        expect(subject.errors).not_to be_empty
      end
    end
  end

  describe ".find_by_date" do
    it "initializes search with default options" do
      now = Time.now
      Time.stub now: now

      PagSeguro::SearchByDate
        .should_receive(:new)
        .with("transactions",
          hash_including(starts_at: now - 86400, ends_at: now, per_page: 50), 0)

      PagSeguro::Transaction.find_by_date
    end

    it "initializes search with given options" do
      starts_at = Time.now - 3600
      ends_at = starts_at + 180
      page = 0

      PagSeguro::SearchByDate
        .should_receive(:new)
        .with(
          "transactions",
          hash_including(per_page: 10, starts_at: starts_at, ends_at: ends_at),
          page
        )

      PagSeguro::Transaction.find_by_date(
        {per_page: 10, starts_at: starts_at, ends_at: ends_at},
        page
      )
    end
  end

  describe ".find_by_reference" do
    it 'initializes search with given reference code' do
      now = Time.now
      Time.stub now: now

      PagSeguro::SearchByReference
        .should_receive(:new)
        .with(
          "transactions",
          hash_including(reference: 'ref1234'),
        )

      PagSeguro::Transaction.find_by_reference('ref1234')
    end
  end

  describe ".find_abandoned" do
    it "initializes search with default options" do
      now = Time.now
      Time.stub now: now

      PagSeguro::SearchAbandoned
        .should_receive(:new)
        .with(
          "transactions/abandoned",
          hash_including(per_page: 50, starts_at: now - 86400, ends_at: now - 900),
          0
        )

      PagSeguro::Transaction.find_abandoned
    end

    it "initializes search with given options" do
      starts_at = Time.now - 3600
      ends_at = starts_at + 180
      page = 1

      PagSeguro::SearchAbandoned
        .should_receive(:new)
        .with(
          "transactions/abandoned",
          hash_including(per_page: 10, starts_at: starts_at, ends_at: ends_at),
          page
        )

      PagSeguro::Transaction.find_abandoned(
        { per_page: 10, starts_at: starts_at, ends_at: ends_at },
        page
      )
    end
  end

  describe "attributes" do
    before do
      body = File.read("./spec/fixtures/transactions/success.xml")
      FakeWeb.register_uri :get, %r[.+], body: body, content_type: "text/xml"
    end

    subject(:transaction) { PagSeguro::Transaction.find_by_notification_code("CODE") }

    it { expect(transaction.sender).to be_a(PagSeguro::Sender) }
    it { expect(transaction.shipping).to be_a(PagSeguro::Shipping) }
    it { expect(transaction.items).to be_a(PagSeguro::Items) }
    it { expect(transaction.payment_method).to be_a(PagSeguro::PaymentMethod) }
    it { expect(transaction.status).to be_a(PagSeguro::PaymentStatus) }
    it { expect(transaction.items.size).to eq(1) }
    it { expect(transaction).to respond_to(:escrow_end_date) }
  end
end
