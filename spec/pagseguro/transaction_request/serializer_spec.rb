require "spec_helper"

describe PagSeguro::TransactionRequest::Serializer do
  let(:transaction_request) { PagSeguro::TransactionRequest.new }
  let(:params) { serializer.to_params }
  subject(:serializer) { described_class.new(transaction_request) }

  before do
    transaction_request.stub({
      payment_method: "creditCard",
    })
  end

  context "global configuration serialization" do
    before do
      PagSeguro.receiver_email = "RECEIVER"
    end

    xit { expect(params).to include(receiverEmail: PagSeguro.receiver_email) }
  end

  context "generic attributes serialization" do
    before do
      transaction_request.stub({
        currency: "BRL",
        reference: "REF123",
        extra_amount: 1234.50,
        notification_url: "NOTIFICATION_URL",
        payment_mode: "default",
        credit_card_token: "4as56d4a56d456as456dsa"
      })
    end

    xit { expect(params).to include(currency: "BRL") }
    xit { expect(params).to include(reference: "REF123") }
    xit { expect(params).to include(extraAmount: "1234.50") }
    xit { expect(params).to include(notificationURL: "NOTIFICATION_URL") }
    xit { expect(params).to include(paymentMethod: "creditCard") }
    xit { expect(params).to include(paymentMode: "default") }
    xit { expect(params).to include(creditCardToken: "4as56d4a56d456as456dsa") }
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
      xit { expect(params).to include("itemId#{index}" => "ID#{index}") }
      xit { expect(params).to include("itemDescription#{index}" => "DESC#{index}") }
      xit { expect(params).to include("itemAmount#{index}" => "#{index}00.12") }
      xit { expect(params).to include("itemShippingCost#{index}" => "#{index}00.34") }
      xit { expect(params).to include("itemQuantity#{index}" => "QTY#{index}") }
      xit { expect(params).to include("itemWeight#{index}" => "WEIGHT#{index}") }
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

    xit { expect(params).to include(bankName: "itau") }
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

      transaction_request.holder = holder
    end

    xit { expect(params).to include(creditCardHolderName: "Jose Comprador") }
    xit { expect(params).to include(creditCardHolderBirthDate: "27/10/1987") }
    xit { expect(params).to include(creditCardHolderCPF: "22111944785") }
    xit { expect(params).to include(creditCardHolderAreaCode: "11") }
    xit { expect(params).to include(creditCardHolderPhone: "56273440") }
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

      transaction_request.stub(billing_address: address)
    end

    xit { expect(params).to include(billingAddressStreet: "STREET") }
    xit { expect(params).to include(billingAddressCountry: "BRA") }
    xit { expect(params).to include(billingAddressState: "STATE") }
    xit { expect(params).to include(billingAddressCity: "CITY") }
    xit { expect(params).to include(billingAddressPostalCode: "POSTAL_CODE") }
    xit { expect(params).to include(billingAddressDistrict: "DISTRICT") }
    xit { expect(params).to include(billingAddressNumber: "NUMBER") }
    xit { expect(params).to include(billingAddressComplement: "COMPLEMENT") }
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

      transaction_request.stub(sender: sender)
    end

    xit { expect(params).to include(senderHash: "HASH") }
    xit { expect(params).to include(senderEmail: "EMAIL") }
    xit { expect(params).to include(senderName: "NAME") }
    xit { expect(params).to include(senderCPF: "CPF") }
    xit { expect(params).to include(senderAreaCode: "AREA_CODE") }
    xit { expect(params).to include(senderPhone: "NUMBER") }
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

    xit { expect(params).to include(shippingType: 1) }
    xit { expect(params).to include(shippingCost: "1234.56") }
    xit { expect(params).to include(shippingAddressStreet: "STREET") }
    xit { expect(params).to include(shippingAddressCountry: "BRA") }
    xit { expect(params).to include(shippingAddressState: "STATE") }
    xit { expect(params).to include(shippingAddressCity: "CITY") }
    xit { expect(params).to include(shippingAddressPostalCode: "POSTAL_CODE") }
    xit { expect(params).to include(shippingAddressDistrict: "DISTRICT") }
    xit { expect(params).to include(shippingAddressNumber: "NUMBER") }
    xit { expect(params).to include(shippingAddressComplement: "COMPLEMENT") }
  end

  context "installment serialization" do
    before do
      transaction_request.installment = PagSeguro::TransactionInstallment.new({
        value: "459.50",
        quantity: "1"
      })
    end

    xit { expect(params).to include(installmentValue: "459.50") }
    xit { expect(params).to include(installmentQuantity: "1") }
  end

  context "extra params serialization" do
    before do
      transaction_request.stub({
        extra_params: [
          { extraParam: 'param_value' },
          { newExtraParam: 'extra_param_value' }
        ]
      })
    end

    xit { expect(params).to include(extraParam: 'param_value') }
    xit { expect(params).to include(newExtraParam: 'extra_param_value') }
  end
end
