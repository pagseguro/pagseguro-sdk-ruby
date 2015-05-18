require "spec_helper"

describe PagSeguro::TransactionRequest do |variable|
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
      expect(subject.extra_params).to eql([])
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
    let(:request) { double(:request) }
    let(:response) { double(:response) }
    let(:params) do
      {receiverEmail: "RECEIVER", currency: "BRL", paymentMethod: "credit_card"}
    end

    before do
      transaction_request.instance_eval do
        def payment_method
          "credit_card"
        end
      end

      expect(PagSeguro::Request).to receive(:post)
        .with("transactions", "v2", params)
        .and_return(request)
      expect(PagSeguro::TransactionRequest::Response).to receive(:new)
        .with(request)
        .and_return(response)
      expect(response).to receive(:serialize).and_return(serialized_data)
    end

    context "when request succeeds" do
      let(:serialized_data) { {code: "123"} }

      it "creates a transaction request" do
        expect(response).to receive(:success?).and_return(true)

        expect(transaction_request.create).to be_truthy
        expect(transaction_request.code).to eq(serialized_data[:code])
      end
    end

    context "when request fails" do
      let(:serialized_data) { {errors: PagSeguro::Errors.new} }

      it "does not create a transaction request" do
        expect(response).to receive(:success?).and_return(false)

        expect(transaction_request.create).to be_falsey
        expect(transaction_request.code).to be_nil
      end
    end
  end
end
