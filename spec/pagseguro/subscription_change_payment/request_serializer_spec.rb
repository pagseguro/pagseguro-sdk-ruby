require 'spec_helper'

describe PagSeguro::SubscriptionChangePayment::RequestSerializer do
  let(:object) do
    PagSeguro::SubscriptionChangePayment.new
  end

  subject { described_class.new(object) }

  context '#serialize' do
    it 'must serialize type' do
      expect(subject.serialize).to match %r[
        .*<paymentMethod>
          .*<type>CREDITCARD
      ]xm
    end

    context "sender's" do
      let(:object) do
        PagSeguro::SubscriptionChangePayment.new(sender: sender)
      end

      let(:sender) do
        PagSeguro::Sender.new(hash: 12345, ip: '192.168.0.1')
      end

      it 'hash' do
        expect(subject.serialize).to match %r[
          .*<paymentMethod>
            .*<sender>
              .*<hash>12345
        ]xm
      end

      it 'ip' do
        expect(subject.serialize).to match %r[
          .*<paymentMethod>
            .*<sender>
              .*<ip>192.168.0.1
        ]xm
      end
    end

    context "payment method's" do
      let(:object) do
        PagSeguro::SubscriptionChangePayment.new(subscription_payment_method: payment_method)
      end

      let(:payment_method) do
        PagSeguro::SubscriptionPaymentMethod.new(token: 'abcd', holder: holder)
      end

      let(:holder) do
        PagSeguro::Holder.new(
          name: 'Holder Name',
          birth_date: Date.new(1990, 12, 31),
          document: {
            type: 'CPF',
            value: '00000000191'
          },
          phone: {
            area_code: 11,
            number: 988881234
          },
          billing_address: {
            street: 'Av Brigadeiro',
            number: '1384',
            complement: '3 andar',
            district: 'Paulistano',
            city: 'Sao Paulo',
            state: 'SP',
            country: 'BRA',
            postal_code: '01452002'
          }
        )
      end

      context "holder's" do
        it "name" do
          expect(subject.serialize).to match %r[
          .*<paymentMethod>
            .*<creditCard>
              .*<holder>
                .*<name>Holder.Name
          ]xm
        end

        it 'birth_date' do
          expect(subject.serialize).to match %r[
          .*<paymentMethod>
            .*<creditCard>
              .*<holder>
                .*<birthDate>31/12/1990
          ]xm
        end

        it 'not include <documents>' do
          expect(subject.serialize).not_to match %r[
          .*<paymentMethod>
            .*<creditCard>
              .*<holder>
                .*<documents>
                  .*<document>
                     .*<type>CPF</type>
                     .*<value>00000000191
          ]xm
        end

        it 'document' do
          expect(subject.serialize).to match %r[
          .*<paymentMethod>
            .*<creditCard>
              .*<holder>
                .*<document>
                   .*<type>CPF</type>
                   .*<value>00000000191
          ]xm
        end

        it 'billing address' do
          expect(subject.serialize).to match %r[
          .*<paymentMethod>
            .*<creditCard>
              .*<holder>
                .*<billingAddress>
                  .*<street>Av.Brigadeiro</street>
                  .*<number>1384</number>
                  .*<complement>3.andar</complement>
                  .*<district>Paulistano</district>
                  .*<city>Sao.Paulo</city>
                  .*<state>SP</state>
                  .*<country>BRA</country>
                  .*<postalCode>01452002
          ]xm
        end

        it 'phone' do
          expect(subject.serialize).to match %r[
          .*<paymentMethod>
            .*<creditCard>
              .*<holder>
                .*<phone>
                  .*<areaCode>11</areaCode>
                  .*<number>988881234
          ]xm
        end
      end
    end
  end
end
