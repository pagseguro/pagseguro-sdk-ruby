require "spec_helper"

describe PagSeguro::TransactionRequest::RequestSerializer do
  let(:transaction_request) { PagSeguro::TransactionRequest.new }
  let(:params) { serializer.to_params }
  subject(:serializer) { described_class.new(transaction_request) }

  before do
    allow(transaction_request).to receive_messages({
      payment_method: "creditCard",
      credit_card_token: "4as56d4a56d456as456dsa"
    })
  end

  context "global configuration serialization" do
    before do
      PagSeguro.configuration.receiver_email = "RECEIVER"
    end

    it { expect(params).to include(receiverEmail: PagSeguro.configuration.receiver_email) }
  end

  context "generic attributes serialization" do
    before do
      allow(transaction_request).to receive_messages({
        currency: "BRL",
        reference: "REF123",
        extra_amount: 1234.50,
        notification_url: "NOTIFICATION_URL",
        payment_mode: "default"
      })
    end

    it { expect(params).to include(currency: "BRL") }
    it { expect(params).to include(reference: "REF123") }
    it { expect(params).to include(extraAmount: "1234.50") }
    it { expect(params).to include(notificationURL: "NOTIFICATION_URL") }
    it { expect(params).to include(paymentMethod: "creditCard") }
    it { expect(params).to include(paymentMode: "default") }
    it { expect(params).to include(creditCardToken: "4as56d4a56d456as456dsa") }
  end

  context "items serialization" do
    def build_item(index)
      PagSeguro::Item.new({
        id: "ID#{index}",
        description: "DESC#{index}",
        quantity: "QTY#{index}",
        amount: index * 100 + 0.12,
        weight: "WEIGHT#{index}",
        shipping_cost: index * 100 + 0.34
      })
    end

    shared_examples_for "item serialization" do |index|
      it { expect(params).to include("itemId#{index}" => "ID#{index}") }
      it { expect(params).to include("itemDescription#{index}" => "DESC#{index}") }
      it { expect(params).to include("itemAmount#{index}" => "#{index}00.12") }
      it { expect(params).to include("itemShippingCost#{index}" => "#{index}00.34") }
      it { expect(params).to include("itemQuantity#{index}" => "QTY#{index}") }
      it { expect(params).to include("itemWeight#{index}" => "WEIGHT#{index}") }
    end

    before do
      transaction_request.items << build_item(1)
      transaction_request.items << build_item(2)
    end

    it_behaves_like "item serialization", 1
    it_behaves_like "item serialization", 2
  end

  context "bank serialization" do
    before do
      allow(transaction_request).to receive(:bank) do
        PagSeguro::Bank.new({name: "itau"})
      end
    end

    it { expect(params).to include(bankName: "itau") }
  end

  context "holder serialization" do
    before do
      holder = PagSeguro::Holder.new({
        name: "Jose Comprador",
        birth_date: "27/10/1987",
        document: {
          type: "CPF",
          value: "22111944785"
        },
        phone: {
          area_code: "11",
          number: "56273440"
        }
      })

      allow(transaction_request).to receive(:holder).and_return(holder)
    end

    it { expect(params).to include(creditCardHolderName: "Jose Comprador") }
    it { expect(params).to include(creditCardHolderBirthDate: "27/10/1987") }
    it { expect(params).to include(creditCardHolderCPF: "22111944785") }
    it { expect(params).to include(creditCardHolderAreaCode: "11") }
    it { expect(params).to include(creditCardHolderPhone: "56273440") }
  end

  context "billing address serialization" do
    before do
      address = PagSeguro::Address.new({
        street: "STREET",
        state: "STATE",
        city: "CITY",
        postal_code: "POSTAL_CODE",
        district: "DISTRICT",
        number: "NUMBER",
        complement: "COMPLEMENT"
      })

      allow(transaction_request).to receive(:billing_address).and_return(address)
    end

    it { expect(params).to include(billingAddressStreet: "STREET") }
    it { expect(params).to include(billingAddressCountry: "BRA") }
    it { expect(params).to include(billingAddressState: "STATE") }
    it { expect(params).to include(billingAddressCity: "CITY") }
    it { expect(params).to include(billingAddressPostalCode: "POSTAL_CODE") }
    it { expect(params).to include(billingAddressDistrict: "DISTRICT") }
    it { expect(params).to include(billingAddressNumber: "NUMBER") }
    it { expect(params).to include(billingAddressComplement: "COMPLEMENT") }
  end

  context "sender serialization" do
    before do
      sender = PagSeguro::Sender.new({
        hash: "HASH",
        email: "EMAIL",
        name: "NAME",
        cpf: "CPF",
        phone: {
          area_code: "AREA_CODE",
          number: "NUMBER"
        }
      })

      allow(transaction_request).to receive(:sender).and_return(sender)
    end

    it { expect(params).to include(senderHash: "HASH") }
    it { expect(params).to include(senderEmail: "EMAIL") }
    it { expect(params).to include(senderName: "NAME") }
    it { expect(params).to include(senderCPF: "CPF") }
    it { expect(params).to include(senderAreaCode: "AREA_CODE") }
    it { expect(params).to include(senderPhone: "NUMBER") }
  end

  context "shipping serialization" do
    before do
      transaction_request.shipping = PagSeguro::Shipping.new({
        type_id: 1,
        cost: 1234.56,
        address: {
          street: "STREET",
          state: "STATE",
          city: "CITY",
          postal_code: "POSTAL_CODE",
          district: "DISTRICT",
          number: "NUMBER",
          complement: "COMPLEMENT"
        }
      })
    end

    it { expect(params).to include(shippingType: 1) }
    it { expect(params).to include(shippingCost: "1234.56") }
    it { expect(params).to include(shippingAddressStreet: "STREET") }
    it { expect(params).to include(shippingAddressCountry: "BRA") }
    it { expect(params).to include(shippingAddressState: "STATE") }
    it { expect(params).to include(shippingAddressCity: "CITY") }
    it { expect(params).to include(shippingAddressPostalCode: "POSTAL_CODE") }
    it { expect(params).to include(shippingAddressDistrict: "DISTRICT") }
    it { expect(params).to include(shippingAddressNumber: "NUMBER") }
    it { expect(params).to include(shippingAddressComplement: "COMPLEMENT") }
  end

  context "installment serialization" do
    before do
      installment = PagSeguro::TransactionInstallment.new({
        value: "459.50",
        quantity: "1"
      })

      allow(transaction_request).to receive(:installment).and_return(installment)
    end

    it { expect(params).to include(installmentValue: "459.50") }
    it { expect(params).to include(installmentQuantity: "1") }
  end

  context "extra params serialization" do
    before do
      allow(transaction_request).to receive_messages({
        extra_params: [
          { extraParam: 'param_value' },
          { newExtraParam: 'extra_param_value' }
        ]
      })
    end

    it { expect(params).to include(extraParam: 'param_value') }
    it { expect(params).to include(newExtraParam: 'extra_param_value') }
  end
end
