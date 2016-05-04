require "spec_helper"

describe PagSeguro::TransactionRequest::RequestSerializer do
  let(:transaction_request) { PagSeguro::BoletoTransactionRequest.new }

  subject { described_class.new(transaction_request) }

  context '#to_xml_params' do
    let(:xml) { subject.to_xml_params }

    it 'should serializer receivers' do
      transaction_request.receivers = [
        {
          public_key: 'PUB1234ABC',
          split: {
            amount: 10,
            fee_percent: 11,
            rate_percent: 12
          }
        }
      ]

      expect(xml).to match %r[
      <payment>
        .*<receivers>
          .*<receiver>
            .*<publicKey>PUB1234ABC</publicKey>
            .*<split>
              .*<amount>10.00</amount>
              .*<ratePercent>12.00</ratePercent>
              .*<feePercent>11.00</feePercent>
        ]xm
    end

    it 'should serializer mode' do
      transaction_request.payment_mode = 'default'

      expect(xml).to match %r[<payment>.*<mode>default</mode>]m
    end

    it 'should serializer method' do
      allow(transaction_request).to receive(:payment_method).and_return('creditCard')

      expect(xml).to match %r[<payment>.*<method>creditCard</method>]m
    end

    context "should serializer sender's" do
      context 'when there is only the name' do
        before do
          transaction_request.sender = { name: 'Alice' }
        end

        it 'should render only the name' do
          expect(xml).to match %r[
          <payment>
            .*<sender>
              .*<name>Alice
          ]xm
        end
      end

      context 'when there is only cpf' do
        before do
          transaction_request.sender = { document: PagSeguro::Document.new(type: 'CPF', value: '12345') }
        end

        it 'document' do
          expect(xml).to match %r[
          <payment>
            .*<sender>
              .*<documents>
                .*<document>
                  .*<type>CPF</type>
                  .*<value>12345</value>
          ]xm
        end
      end

      context 'when there is only cnpj' do
        before do
          transaction_request.sender = {
            document: PagSeguro::Document.new(type: 'CNPJ', value: '62057673000135')
          }
        end

        it 'should render only the name' do
          expect(xml).to match %r[
          <payment>
            .*<sender>
              .*<documents>
                .*<document>
                  .*<type>CNPJ</type>
                  .*<value>62057673000135</value>
          ]xm
        end
      end

      context 'when there are all fields' do
        before do
          transaction_request.sender = {
            name: 'Alice',
            email: 'alice@example.com',
            hash: 'hash1234',
            phone: {
              area_code: 12,
              number: "23456789"
            },
            documents: [
              { type: 'CNPJ', value: '62057673000135' },
              { type: 'CPF', value: '00242866131' }
            ]
          }
        end

        it 'name' do
          expect(xml).to match %r[
          <payment>
            .*<sender>
              .*<name>Alice</name>
            ]xm
        end

        it 'email' do
          expect(xml).to match %r[
          <payment>
            .*<sender>
              .*<email>alice@example.com</email>
          ]xm
        end

        it 'phone' do
          expect(xml).to match %r[
          <payment>
            .*<sender>
              .*<phone>
                .*<areaCode>12</areaCode>
                .*<number>23456789</number>
          ]xm
        end

        it 'cpf' do
          expect(xml).to match %r[
          <payment>
            .*<sender>
              .*<documents>
                .*<document>
                  .*<type>CPF</type>
                  .*<value>00242866131</value>
          ]xm
        end

        it 'other documents' do
          expect(xml).to match %r[
          <payment>
            .*<sender>
              .*<documents>
                .*<document>
                  .*<type>CNPJ</type>
                  .*<value>62057673000135</value>
                .*</document>
                .*<document>
                  .*<type>CPF</type>
                  .*<value>00242866131</value>
          ]xm
        end

        it 'hash' do
          expect(xml).to match %r[
          <payment>
            .*<sender>
              .*<hash>hash1234</hash>
          ]xm
        end
      end
    end

    it 'should serialize currency' do
      transaction_request.currency = 'BRL'

      expect(xml).to match %r[
      <payment>
        .*<currency>BRL</currency>
      ]xm
    end

    it 'should serialize notificationURL' do
      transaction_request.notification_url = 'http://www1.example.com/'

      expect(xml).to match %r[
      <payment>
        .*<notificationURL>http://www1.example.com/</notificationURL>
      ]xm
    end

    context "should serialize item's" do
      before do
        transaction_request.items << {
          id: 123,
          description: 'TV',
          quantity: 300,
          amount: 150
        }
      end

      it 'id' do
        expect(xml).to match %r[
        <payment>
          .*<items>
            .*<item>
              .*<id>123</id>
        ]xm
      end

      it 'description' do
        expect(xml).to match %r[
        <payment>
          .*<items>
            .*<item>
              .*<description>TV</description>
        ]xm
      end

      it 'quantity' do
        expect(xml).to match %r[
        <payment>
          .*<items>
            .*<item>
              .*<quantity>300</quantity>
        ]xm
      end

      it 'amount' do
        expect(xml).to match %r[
        <payment>
          .*<items>
            .*<item>
              .*<amount>150.00</amount>
        ]xm
      end
    end

    it 'should serialize empty extraAmount' do
      transaction_request.extra_amount = nil

      expect(xml).to match %r[
      <payment>
        .*<extraAmount>0.00</extraAmount>
      ]xm
    end

    it 'should serialize extraAmount' do
      transaction_request.extra_amount = 100

      expect(xml).to match %r[
      <payment>
        .*<extraAmount>100.00</extraAmount>
      ]xm
    end

    it 'should serialize reference' do
      transaction_request.reference = 'ref123'

      expect(xml).to match %r[
      <payment>
        .*<reference>ref123</reference>
      ]xm
    end

    context "should serialize address's" do
      before do
        transaction_request.shipping = PagSeguro::Shipping.new(
          address: {
            street: 'One Avenue',
            number: 1234,
            complement: '1st floor',
            district: 'Somewhere',
            city: 'Somewhere City',
            state: 'ST',
            country: 'BRA',
            postal_code: '01234567'
          }
        )
      end

      it 'street' do
        expect(xml).to match %r[
        <payment>
          .*<shipping>
            .*<address>
                .*<street>One.Avenue</street>
        ]xm
      end

      it 'number' do
        expect(xml).to match %r[
        <payment>
          .*<shipping>
            .*<address>
                .*<number>1234</number>
        ]xm
      end

      it 'complement' do
        expect(xml).to match %r[
        <payment>
          .*<shipping>
            .*<address>
                .*<complement>1st.floor</complement>
        ]xm
      end

      it 'district' do
        expect(xml).to match %r[
        <payment>
          .*<shipping>
            .*<address>
                .*<district>Somewhere</district>
        ]xm
      end

      it 'city' do
        expect(xml).to match %r[
        <payment>
          .*<shipping>
            .*<address>
                .*<city>Somewhere.City</city>
        ]xm
      end

      it 'state' do
        expect(xml).to match %r[
        <payment>
          .*<shipping>
            .*<address>
                .*<state>ST</state>
        ]xm
      end

      it 'country' do
        expect(xml).to match %r[
        <payment>
          .*<shipping>
            .*<address>
                .*<country>BRA</country>
        ]xm
      end

      it 'postalCode' do
        expect(xml).to match %r[
        <payment>
          .*<shipping>
            .*<address>
                .*<postalCode>01234567</postalCode>
        ]xm
      end
    end

    context "should serializer credit card info about" do
      let(:transaction_request) do
        PagSeguro::CreditCardTransactionRequest.new(
          credit_card_token: 'tok123',
          installment: {
            quantity: 10,
            value: 50
          },
          holder: {
            name: 'John',
            document: { type: 'CPF', value: '870' },
            birth_date: '20/10/1980',
            phone: { area_code: 11, number: 999991111 }
          },
          billing_address: {
            street: 'Lima',
            complement: '1 andar',
            number: 1384,
            district: 'Jardim Paulistano',
            city: 'Sao Paulo',
            state: 'SP',
            country: 'BRA',
            postal_code: '014',
          }
        )
      end

      before do
        transaction_request.sender = { name: 'Alice' }
      end

      it 'token' do
        expect(xml).to match %r[
        <payment>
          .*<creditCard>
            .*<token>tok123</token>
        ]xm
      end

      it 'installment' do
        expect(xml).to match %r[
        <payment>
          .*<creditCard>
            .*<installment>
              .*<quantity>10</quantity>
              .*<value>50.00
        ]xm
      end

      it 'holder' do
        expect(xml).to match %r[
        <payment>
          .*<creditCard>
            .*<holder>
              .*<name>John</name>
              .*<documents>
                .*<document>
                  .*<type>CPF</type>
                  .*<value>870</value>
                .*</document>
              .*</documents>
              .*<birthDate>20/10/1980</birthDate>
              .*<phone>
                .*<areaCode>11</areaCode>
                .*<number>999991111</number>
        ]xm
      end

      it 'billingAddress' do
        expect(xml).to match %r[
        <payment>
          .*<creditCard>
            .*<billingAddress>
                .*<street>Lima</street>
                .*<number>1384</number>
                .*<complement>1.andar</complement>
                .*<district>Jardim.Paulistano</district>
                .*<city>Sao.Paulo</city>
                .*<state>SP</state>
                .*<country>BRA</country>
                .*<postalCode>014</postalCode>
        ]xm
      end
    end
  end

  context '#to_params' do
    let(:params) { subject.to_params }

    before do
      allow(transaction_request).to receive_messages({
        payment_method: "creditCard",
        credit_card_token: "4as56d4a56d456as456dsa"
      })
    end

    context "global configuration serialization" do
      before do
        PagSeguro.configuration.receiver_email = "receiver@example.com"
      end

      it { expect(params).to include(receiverEmail: "receiver@example.com") }
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

    context "sender serialization with CPF" do
      before do
        sender = PagSeguro::Sender.new({
          hash: "HASH",
          email: "EMAIL",
          name: "NAME",
          document: { type: "CPF", value: "CPF" },
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

    context "sender serialization with CNPJ" do
      before do
        sender = PagSeguro::Sender.new({
          hash: "HASH",
          email: "EMAIL",
          name: "NAME",
          document: { type: "CNPJ", value: "CNPJ" },
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
      it { expect(params).to include(senderCNPJ: "CNPJ") }
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
end
