require 'spec_helper'

shared_examples 'when address is assigned' do
  it 'can have a postal code' do
    address[:postal_code] = '01452002'

    postal_code_parsed = node.at_css('> postalCode').text
    expect(postal_code_parsed).to eq '01452002'
  end

  it 'can have a street' do
    address[:street] = 'Av. Brig. Faria Lima'

    street_parsed = node.at_css('> street').text
    expect(street_parsed).to eq 'Av. Brig. Faria Lima'
  end

  it 'can have a number' do
    address[:number] = '1384'

    number_parsed = node.at_css('> number').text
    expect(number_parsed).to eq '1384'
  end

  it 'can have a complement' do
    address[:complement] = '5o andar'

    complement_parsed = node.at_css('> complement').text
    expect(complement_parsed).to eq '5o andar'
  end

  it 'can have a district' do
    address[:district] = 'Jardim Paulistano'

    district_parsed = node.at_css('> district').text
    expect(district_parsed).to eq 'Jardim Paulistano'
  end

  it 'can have a city' do
    address[:city] = 'Sao Paulo'

    city_parsed = node.at_css('> city').text
    expect(city_parsed).to eq 'Sao Paulo'
  end

  it 'can have a state' do
    address[:state] = 'SP'

    state_parsed = node.at_css('> state').text
    expect(state_parsed).to eq 'SP'
  end

  it 'can have a country' do
    address[:country] = 'BRA'

    country_parsed = node.at_css('> country').text
    expect(country_parsed).to eq 'BRA'
  end
end

shared_examples 'when documents is assigned' do
  context 'when one document is given' do
    before do
      documents << { type: 'CPF', value: '99988877766' }
    end

    let(:documents_parsed) { node.css('> document') }

    it 'must have the correct type' do
      expect( documents_parsed.at_css('> type').text ).to eq 'CPF'
    end

    it 'must have the correct value' do
      expect( documents_parsed.at_css('> value').text ).to eq '99988877766'
    end
  end

  context 'when multiple documents is given' do
    before do
      documents << { type: 'CPF', value: '99988877766' }
      documents << { type: 'CNPJ', value: '17302417000101' }
    end

    let(:documents_parsed) do
      node.css('> document').map do |node|
        {
          type: node.at_css('> type').text,
          value: node.at_css('> value').text
        }
      end
    end

    it 'must have the correct number of documents' do
      expect(documents_parsed.size).to eq 2
    end

    it 'must have the correct documents' do
      expect(documents_parsed).to contain_exactly(
        { type: 'CPF', value: '99988877766' },
        { type: 'CNPJ', value: '17302417000101' }
      )
    end
  end
end

shared_examples 'when phones is assigned' do
  context 'when one phone is given' do
    before do
      phones << { type: 'HOME', area_code: '11', number: '30302323' }
    end

    let(:phone_parsed) { node.at_css('> phone') }

    it 'must have a type' do
      expect( phone_parsed.at_css('> type').text ).to eq 'HOME'
    end

    it 'must have an area code' do
      expect( phone_parsed.at_css('> areaCode').text ).to eq '11'
    end

    it 'must have a number' do
      expect( phone_parsed.at_css('> number').text ).to eq '30302323'
    end
  end

  context 'can have multiple phones' do
    before do
      phones << { type: 'HOME', area_code: '11', number: '30302323' }
      phones << { type: 'MOBILE', area_code: '11', number: '976302323' }
    end

    let(:phones_parsed) do
      node.css('> phone').map do |phone|
        {
          type: phone.at_css('> type').text,
          area_code: phone.at_css('> areaCode').text,
          number: phone.at_css('> number').text
        }
      end
    end

    it 'must have the correct number of phones' do
      expect(phones_parsed.size).to eq 2
    end

    it 'must have the correct phones' do
      expect(phones_parsed).to contain_exactly(
        { type: 'HOME', area_code: '11', number: '30302323' },
        { type: 'MOBILE', area_code: '11', number: '976302323' }
      )
    end
  end
end

describe PagSeguro::AuthorizationRequest::RequestSerializer do
  let(:credentials) { PagSeguro::ApplicationCredentials.new('app123', 'key123') }
  let(:options) do
    {
      credentials: credentials,
      permissions: [:checkouts, :searches, :notifications],
      notification_url: 'http://seusite.com.br/redirect',
      redirect_url: 'http://seusite.com.br/notification'
    }
  end

  let(:authorization_request) { PagSeguro::AuthorizationRequest.new(options) }
  let(:serializer) { described_class.new(authorization_request) }
  let(:xml) { serializer.build_xml }
  let(:xml_parsed) { Nokogiri::XML(xml) }
  let(:node) { xml_parsed.at_css('authorizationRequest') }

  it 'encoding should be equal to application encoding' do
    encoding = xml_parsed.encoding
    expect(encoding).to eq PagSeguro.encoding
  end

  it 'must have a authorizationRequest' do
    expect(node).to be_a_instance_of Nokogiri::XML::Element
  end

  it 'must have the correct permissions' do
    permissions = options[:permissions].map{|value| PagSeguro::AuthorizationRequest::PERMISSIONS[value] }
    permissions_code_parsed = xml_parsed.css('authorizationRequest > permissions > code').map(&:text)

    expect(permissions).to eq permissions_code_parsed
  end

  it 'must have a redirect URL' do
    redirect_url_parsed = xml_parsed.at_css('authorizationRequest > redirectURL').text
    expect(redirect_url_parsed).to eq options[:redirect_url]
  end

  it 'must have a notification URL' do
    notification_url = xml_parsed.at_css('authorizationRequest > notificationURL').text
    expect(notification_url).to eq options[:notification_url]
  end

  context 'when an account is assigned' do
    let(:account) { {} }
    let(:options) { super().merge(account: account) }
    let(:node) { super().at_css('> account') }

    it 'can have an email' do
      account[:email] = 'usuario@seusite.com.br'
      expect( node.at_css('> email').text ).to eq 'usuario@seusite.com.br'
    end

    it 'can have a type' do
      account[:type] = 'SELLER'
      expect( node.at_css('> type').text ).to eq 'SELLER'
    end

    context 'when a person is assigned'  do
      let(:person) { {} }
      let(:account) { super().merge(person: person) }
      let(:node) { super().at_css('> person') }

      it 'can have name' do
        person[:name] = 'Antonio Carlos'
        expect( node.at_css('> name').text ).to eq 'Antonio Carlos'
      end

      it 'can have birth date' do
        person[:birth_date] = Date.new(1982, 2, 5)
        expect( node.at_css('> birthDate').text ).to eq '1982-02-05'
      end

      context 'when the address is assigned' do
        let(:address) { {} }
        let(:person) { super().merge(address: address) }
        let(:node) { super().at_css('> address') }

        include_examples 'when address is assigned'
      end

      context 'when the documents is assigned' do
        let(:documents) { [] }
        let(:person) { super().merge({ documents: documents }) }
        let(:node) { super().at_css('> documents') }

        include_examples 'when documents is assigned'
      end

      context 'when the phones' do
        let(:phones) { [] }
        let(:person) { super().merge({ phones: phones }) }
        let(:node) { super().at_css('> phones') }

        include_examples 'when phones is assigned'
      end
    end

    context 'when the company is assigned' do
      let(:company) { {} }
      let(:account) { super().merge({ company: company }) }
      let(:node) { super().at_css('> company') }

      it 'can have a name' do
        company[:name] = 'Seu Site'
        expect( node.at_css('> name').text ).to eq 'Seu Site'
      end

      it 'can have a display name' do
        company[:display_name] = 'Seu Site'
        expect( node.at_css('> displayName').text ).to eq 'Seu Site'
      end

      it 'can have a website url' do
        company[:website_url] = 'http://www.seusite.com.br'
        expect( node.at_css('> websiteURL').text ).to eq 'http://www.seusite.com.br'
      end

      context 'when the address is assigned' do
        let(:address) { {} }
        let(:company) { super().merge(address: address) }
        let(:node) { super().at_css('> address') }

        include_examples 'when address is assigned'
      end

      context 'when the documents is assigned' do
        let(:documents) { [] }
        let(:company) { super().merge({ documents: documents }) }
        let(:node) { super().at_css('> documents') }

        include_examples 'when documents is assigned'
      end

      context 'when the phones is assigned' do
        let(:phones) { [] }
        let(:company) { super().merge({ phones: phones }) }
        let(:node) { super().at_css('> phones') }

        include_examples 'when phones is assigned'
      end

      context 'when the partner is assigned' do
        let(:partner) { {} }
        let(:company) { super().merge({ partner: partner }) }
        let(:node) { super().at_css('> partner') }

        it 'can have a name' do
          partner[:name] = 'Antonio Carlos'
          expect( node.at_css('> name').text ).to eq 'Antonio Carlos'
        end

        it 'can have a birth date' do
          partner[:birth_date] = Date.new(1982, 2, 5)
          expect( node.at_css('> birthDate').text ).to eq '1982-02-05'
        end

        context 'when the documents is assigned' do
          let(:documents) { [] }
          let(:partner) { super().merge({ documents: documents }) }
          let(:node) { super().at_css('> documents') }

          include_examples 'when documents is assigned'
        end
      end
    end
  end
end
