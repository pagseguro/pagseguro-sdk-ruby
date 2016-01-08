require "spec_helper"

describe PagSeguro::PaymentRequest do
  it_assigns_attribute :currency
  it_assigns_attribute :redirect_url
  it_assigns_attribute :extra_amount
  it_assigns_attribute :reference
  it_assigns_attribute :max_age
  it_assigns_attribute :max_uses
  it_assigns_attribute :notification_url
  it_assigns_attribute :abandon_url

  it_ensures_type PagSeguro::Sender, :sender
  it_ensures_type PagSeguro::Shipping, :shipping

  it "sets the sender" do
    sender = PagSeguro::Sender.new
    payment = PagSeguro::PaymentRequest.new(sender: sender)

    expect(payment.sender).to eql(sender)
  end

  context 'sets receivers' do
    let(:subject) do
      PagSeguro::PaymentRequest.new(receivers: receivers)
    end

    let(:receivers) do
      [
        {
          email: 'a@example.com',
          split: { amount: 1 }
        },
        {
          email: 'b@example.com',
          split: { amount: 1 }
        }
      ]
    end

    it "ensure they are PagSeguro::Receiver" do
      subject.receivers.each do |receiver|
        expect(receiver).to be_a(PagSeguro::Receiver)
      end
    end

    it "ensure they have correct keys" do
      expect(subject.receivers[0].email).to eq 'a@example.com'
    end

    it "changes url to checkouts" do
      expect(PagSeguro::Request).to receive(:post).with(
        'checkouts', 'v2',
        {
          receiverEmail: 'RECEIVER',
          currency: 'BRL',
          'receiver[1].email' => 'a@example.com',
          'receiver[1].split.amount' => 1,
          'receiver[2].email' => 'b@example.com',
          'receiver[2].split.amount' => 1
        }
      )

      subject.register
    end
  end

  it "sets the items" do
    payment = PagSeguro::PaymentRequest.new
    expect(payment.items).to be_a(PagSeguro::Items)
  end

  it "sets default currency" do
    payment = PagSeguro::PaymentRequest.new
    expect(payment.currency).to eql("BRL")
  end

  describe "#register" do
    let(:payment) { PagSeguro::PaymentRequest.new }
    before { FakeWeb.register_uri :any, %r[.*?], body: "" }

    it "serializes payment request" do
      allow_any_instance_of(PagSeguro::PaymentRequest::RequestSerializer)
        .to receive(:new)
        .with(payment)
        .and_return(double.as_null_object)

      payment.register
    end

    it "performs request" do
      params = double(:Params)

      allow_any_instance_of(PagSeguro::PaymentRequest::RequestSerializer).to receive(:to_params).and_return(params)

      expect(PagSeguro::Request)
        .to receive(:post)
        .with("checkout", "v2", params)

      payment.register
    end

    it "initializes response" do
      response = double
      allow(PagSeguro::Request).to receive(:post).and_return(response)

      expect(PagSeguro::PaymentRequest::Response)
        .to receive(:new)
        .with(response)

      payment.register
    end

    it "returns response" do
      response = double
      allow(PagSeguro::PaymentRequest::Response).to receive(:new).and_return(response)

      expect(payment.register).to eql(response)
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
end
