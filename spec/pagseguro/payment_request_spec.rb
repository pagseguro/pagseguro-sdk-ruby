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
  it_assigns_attribute :email
  it_assigns_attribute :token

  it_ensures_type PagSeguro::Sender, :sender
  it_ensures_type PagSeguro::Shipping, :shipping

  it "sets the sender" do
    sender = PagSeguro::Sender.new
    payment = PagSeguro::PaymentRequest.new(sender: sender)

    expect(payment.sender).to eql(sender)
  end

  it "sets the items" do
    payment = PagSeguro::PaymentRequest.new
    expect(payment.items).to be_a(PagSeguro::Items)
  end

  it "sets default currency" do
    payment = PagSeguro::PaymentRequest.new
    expect(payment.currency).to eql("BRL")
  end

  describe "#email" do
    before { PagSeguro.email = 'DEFAULT_EMAIL' }

    it "returns the email set in the constructor" do
      expect(described_class.new(email: 'foo').email).to eq('foo')
    end

    it "defaults to PagSeguro.email" do
      expect(described_class.new.email).to eq('DEFAULT_EMAIL')
    end
  end

  describe "#token" do
    before { PagSeguro.token = 'DEFAULT_TOKEN' }

    it "returns the token set in the constructor" do
      expect(described_class.new(token: 'foo').token).to eq('foo')
    end

    it "defaults to PagSeguro.token" do
      expect(described_class.new.token).to eq('DEFAULT_TOKEN')
    end
  end

  describe "#register" do
    let(:payment) { PagSeguro::PaymentRequest.new }
    before { FakeWeb.register_uri :any, %r[.*?], body: "" }

    it "serializes payment request" do
      PagSeguro::PaymentRequest::Serializer
        .should_receive(:new)
        .with(payment)
        .and_return(double.as_null_object)

      payment.register
    end

    it "performs request" do
      params = double

      params.should_receive(:merge).with({
        email: PagSeguro.email,
        token: PagSeguro.token
      }).and_return(params)

      PagSeguro::PaymentRequest::Serializer.any_instance.stub to_params: params

      PagSeguro::Request
        .should_receive(:post)
        .with("checkout", "v2", params)

      payment.register
    end

    it "initializes response" do
      response = double
      PagSeguro::Request.stub post: response

      PagSeguro::PaymentRequest::Response
        .should_receive(:new)
        .with(response)

      payment.register
    end

    it "returns response" do
      response = double
      PagSeguro::PaymentRequest::Response.stub new: response

      expect(payment.register).to eql(response)
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
end
