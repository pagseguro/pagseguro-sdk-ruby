require 'spec_helper'

describe PagSeguro::Subscription::RequestSerializer do
  let(:subscription) { PagSeguro::Subscription.new }
  let(:xml) { described_class.new(subscription).serialize }

  context 'serialize' do
    it 'plan attribute' do
      subscription.plan = '89A1108EFEFE7A8EE4065FAD7872DE0D'
      expect(xml).to match %r[
        <directPreApproval>
          .*<plan>89A1108EFEFE7A8EE4065FAD7872DE0D</plan>
      ]xm
    end

    it 'reference attribute' do
      subscription.reference = 'ID-CND'
      expect(xml).to match %r[
        <directPreApproval>
          .*<reference>ID-CND</reference>
      ]xm
    end

    context 'sender attributes' do
      before do
        subscription.sender = {
          name: 'Comprador',
          email: 'user@example.com',
          ip: '192.168.0.1',
          hash: 'hash',
          phone: {
            area_code: 12,
            number: '23456789'
          },
          document: { type: 'CPF', value: '23606838450' },
          address: {
            street: 'Av Brigadeira Faria Lima',
            number: '1384',
            complement: '3 andar',
            district: 'Jd Paulistano',
            city: 'Sao Paulo',
            state: 'SP',
            country: 'BRA',
            postal_code: '01452002'
          }
        }
      end

      it 'name attribute' do
        expect(xml).to match %r[
          <directPreApproval>
            .*<sender>
              .*<name>Comprador</name>
        ]xm
      end

      it 'email attribute' do
        expect(xml).to match %r[
          <directPreApproval>
            .*<sender>
              .*<email>user@example.com</email>
        ]xm
      end

      it 'ip attribute' do
        expect(xml).to match %r[
          <directPreApproval>
            .*<sender>
              .*<ip>192.168.0.1</ip>
        ]xm
      end

      it 'hash attribute' do
        expect(xml).to match %r[
          <directPreApproval>
            .*<sender>
              .*<hash>hash</hash>
        ]xm
      end

      it 'phone attribute' do
        expect(xml).to match %r[
          <directPreApproval>
            .*<sender>
              .*<phone>
                .*<areaCode>12</areaCode>
                .*<number>23456789</number>
              .*</phone>
        ]xm
      end

      it 'address attribute' do
        expect(xml).to match %r[
          <directPreApproval>
            .*<sender>
              .*<address>
                .*<street>Av\ Brigadeira\ Faria\ Lima</street>
                .*<number>1384</number>
                .*<complement>3\ andar</complement>
                .*<district>Jd\ Paulistano</district>
                .*<city>Sao\ Paulo</city>
                .*<state>SP</state>
                .*<country>BRA</country>
                .*<postalCode>01452002</postalCode>
              .*</address>
        ]xm
      end

      it 'documents attribute' do
        expect(xml).to match %r[
          <directPreApproval>
            .*<sender>
              .*<documents>
                .*<document>
                  .*<type>CPF</type>
                  .*<value>23606838450</value>
                .*</document>
              .*</documents>
        ]xm
      end
    end

    context 'payment method attributes' do
      before do
        subscription.payment_method = {
          token: 'd05df2a777de4c4f882b3e8aaef09030',
          holder: {
            name: 'Nome',
            birth_date: '11/01/1984',
            document: { type: 'CPF', value: '00000000191' },
            billing_address: {
              street: 'Av Brigadeira Faria Lima',
              number: '1384',
              complement: '3 andar',
              district: 'Jd Paulistano',
              city: 'Sao Paulo',
              state: 'SP',
              country: 'BRA',
              postal_code: '01452002'
            },
            phone: { area_code: '11', number: '988881234' }
          }
        }
      end

      it 'type attribute' do
        expect(xml).to match %r[
          <directPreApproval>
            .*<paymentMethod>
              .*<type>CREDITCARD</type>
        ]xm
      end

      context 'creditcard attributes' do
        it 'token attribute' do
          expect(xml).to match %r[
            <directPreApproval>
              .*<paymentMethod>
                .*<creditCard>
                  .*<token>d05df2a777de4c4f882b3e8aaef09030</token>
          ]xm
        end

        context 'holder attributes' do
          it 'name attribute' do
            expect(xml).to match %r[
              <directPreApproval>
                .*<paymentMethod>
                  .*<creditCard>
                    .*<holder>
                      .*<name>Nome</name>
            ]xm
          end

          it 'birth_date attribute' do
            expect(xml).to match %r[
              <directPreApproval>
                .*<paymentMethod>
                  .*<creditCard>
                    .*<holder>
                      .*<birthDate>11/01/1984</birthDate>
            ]xm
          end

          it 'document attribute' do
            expect(xml).to match %r[
              <directPreApproval>
                .*<paymentMethod>
                  .*<creditCard>
                    .*<holder>
                      .*<document>
                        .*<type>CPF</type>
                        .*<value>00000000191</value>
                      .*</document>
            ]xm
          end

          it 'billing_address attributes' do
            expect(xml).to match %r[
              <directPreApproval>
                .*<paymentMethod>
                  .*<creditCard>
                    .*<holder>
                      .*<billingAddress>
                        .*<street>Av\ Brigadeira\ Faria\ Lima</street>
                        .*<number>1384</number>
                        .*<complement>3\ andar</complement>
                        .*<district>Jd\ Paulistano</district>
                        .*<city>Sao\ Paulo</city>
                        .*<state>SP</state>
                        .*<country>BRA</country>
                        .*<postalCode>01452002</postalCode>
                      .*</billingAddress>
            ]xm
          end

          it 'phone attributes' do
            expect(xml).to match %r[
              <directPreApproval>
                .*<paymentMethod>
                  .*<creditCard>
                    .*<holder>
                      .*<phone>
                        .*<areaCode>11</areaCode>
                        .*<number>988881234</number>
                      .*</phone>
            ]xm
          end
        end
      end
    end
  end
end
