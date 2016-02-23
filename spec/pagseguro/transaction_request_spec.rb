require "spec_helper"

describe PagSeguro::TransactionRequest do |variable|
  let(:xml_parsed) { Nokogiri::XML(raw_xml) }

  it_assigns_attribute :currency
  it_assigns_attribute :extra_amount
  it_assigns_attribute :reference
  it_assigns_attribute :notification_url
  it_assigns_attribute :payment_mode
  it_assigns_attribute :extra_params

  it_ensures_type PagSeguro::Sender, :sender
  it_ensures_type PagSeguro::Shipping, :shipping

  it { is_expected.to respond_to(:code) }
  it { is_expected.to respond_to(:type_id) }
  it { is_expected.to respond_to(:payment_link) }
  it { is_expected.to respond_to(:status) }
  it { is_expected.to respond_to(:payment_method) }
  it { is_expected.to respond_to(:gross_amount) }
  it { is_expected.to respond_to(:discount_amount) }
  it { is_expected.to respond_to(:net_amount) }
  it { is_expected.to respond_to(:installment_count) }
  it { is_expected.to respond_to(:created_at) }
  it { is_expected.to respond_to(:updated_at) }

  it "sets the sender" do
    sender = PagSeguro::Sender.new
    payment = PagSeguro::TransactionRequest.new(sender: sender)

    expect(payment.sender).to eql(sender)
  end

  it "sets shipping" do
    shipping = PagSeguro::Shipping.new
    payment = PagSeguro::TransactionRequest.new(shipping: shipping)

    expect(payment.shipping).to eql(shipping)
  end

  it "sets the items" do
    payment = PagSeguro::TransactionRequest.new
    expect(payment.items).to be_a(PagSeguro::Items)
  end

  it "sets default currency" do
    payment = PagSeguro::TransactionRequest.new
    expect(payment.currency).to eql("BRL")
  end

  describe "#payment_method" do
    it "raises not implemented error" do
      expect { subject.payment_method }.to raise_error(NotImplementedError)
    end
  end

  describe "#extra_params" do
    it "is empty before initialization" do
      expect(subject.extra_params).to be_empty
    end

    it "allows extra parameter addition" do
      subject.extra_params << { extraParam: 'value' }
      subject.extra_params << { itemParam1: 'value1' }

      expect(subject.extra_params).to eql([
        { extraParam: 'value' },
        { itemParam1: 'value1' }
      ])
    end
  end

  describe "#create" do
    let(:transaction_request) { PagSeguro::TransactionRequest.new }
    let(:request) { double(:request, success?: true, xml?: true, body: raw_xml) }
    let(:params) do
      {receiverEmail: "RECEIVER", currency: "BRL", paymentMethod: "credit_card"}
    end

    before do
      PagSeguro.configuration.receiver_email = "RECEIVER"

      allow(transaction_request).to receive(:payment_method).and_return("credit_card")

      allow(PagSeguro::Request).to receive(:post)
        .with("transactions", "v2", params)
        .and_return(request)
    end

    context "when request succeeds" do
      let(:raw_xml) { File.read("./spec/fixtures/transaction_request/success.xml") }

      it "creates a transaction request" do
        expect(transaction_request.create).to be_a(PagSeguro::TransactionRequest)
        expect(transaction_request.code).to eq("9E884542-81B3-4419-9A75-BCC6FB495EF1")
      end
    end

    context "when request fails" do
      let :response_request do
        double(
          :ResponseRequest,
          success?: false,
          error?: true,
          bad_request?: true,
          error: Aitch::BadRequestError,
          xml?: true,
          data: xml_parsed,
          body: raw_xml
        )
      end

      before do
        allow(PagSeguro::Request).to receive(:post)
          .and_return(response_request)
      end

      let(:raw_xml) { File.read("./spec/fixtures/invalid_code.xml") }

      it "does not create a transaction request" do
        expect { transaction_request.create }.not_to change { transaction_request.code }
      end

      it "add errors" do
        expect { transaction_request.create }.to change { transaction_request.errors.empty? }
      end
    end
  end
end
