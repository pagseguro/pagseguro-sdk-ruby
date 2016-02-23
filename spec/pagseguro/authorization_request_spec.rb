require 'spec_helper'

describe PagSeguro::AuthorizationRequest do
  it_assigns_attribute :permissions
  it_assigns_attribute :reference
  it_assigns_attribute :notification_url
  it_assigns_attribute :redirect_url

  describe "#create" do
    let(:request) { double(:request) }
    let(:response) { double(:response) }
    let(:credentials) { PagSeguro::ApplicationCredentials.new('app123', 'key123') }

    before do
      expect(PagSeguro::Request).to receive(:post_xml)
        .with('authorizations/request', 'v2', credentials, data)
        .and_return(request)

      expect(PagSeguro::AuthorizationRequest::Response).to receive(:new)
        .with(request)
        .and_return(response)

      expect(response).to receive(:serialize).and_return(serialized_data)
    end

    context "when an account is not given" do
      let(:options) do
        {
          credentials: credentials,
          notification_url: 'http://seusite.com.br/notification',
          redirect_url: 'http://seusite.com.br/redirect',
          permissions: [:checkouts, :searches, :notifications],
          reference: '123'
        }
      end

      let(:data) { File.read('./spec/fixtures/authorization_request/authorization_request.xml') }

      subject { described_class.new(options) }

      context "when request succeeds" do
        let(:serialized_data) { {code: "123"} }

        it "creates a transaction request" do
          expect(response).to receive(:success?).and_return(true)

          expect(subject.create).to be_truthy
          expect(subject.code).to eq(serialized_data[:code])
        end
      end


      context "when request fails" do
        let(:serialized_data) { {errors: PagSeguro::Errors.new} }

        it "does not create a transaction request" do
          expect(response).to receive(:success?).and_return(false)

          expect(subject.create).to be_falsey
          expect(subject.code).to be_nil
        end
      end
    end

    context "when an account is given" do
      let(:options) do
        {
          credentials: credentials,
          permissions: [:checkouts, :searches, :notifications],
          notification_url: 'http://seusite.com.br/notification',
          redirect_url: 'http://seusite.com.br/redirect',
          reference: '123',
          account: {
            email: 'usuario@seusite.com.br',
            type: 'SELLER',
            person: {
              name: 'Antonio Carlos',
              birth_date: '05/02/1982',
              address: {
                postal_code: 01452002,
                street: 'Av. Brig. Faria Lima',
                number: 1384,
                complement: '5o andar',
                district: 'Jardim Paulistano',
                city: 'Sao Paulo',
                state: 'SP',
                country: 'BRA'
              },
              documents: [{type: 'CPF', value: 99988877766}],
              phones: [
                {type: 'HOME', area_code: 11, number: 30302323},
                {type: 'MOBILE', area_code: 11, number: 976302323},
              ]
            }
          }
        }
      end
      let(:data) { File.read('./spec/fixtures/authorization_request/authorization_request_with_account.xml') }
      let(:request) { double(:request) }
      let(:response) { double(:response) }

      subject { described_class.new(options) }

      context "when request succeeds" do
        let(:serialized_data) { {code: "123"} }

        it "creates a transaction request send xml" do
          expect(response).to receive(:success?).and_return(true)

          expect(subject.create).to be_truthy
          expect(subject.code).to eq(serialized_data[:code])
        end
      end

      context "when request fails" do
        let(:serialized_data) { {errors: PagSeguro::Errors.new} }

        it "does not create a transaction request" do
          expect(response).to receive(:success?).and_return(false)

          expect(subject.create).to be_falsey
          expect(subject.code).to be_nil
        end
      end
    end
  end
end
