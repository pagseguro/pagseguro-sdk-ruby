require 'spec_helper'

describe PagSeguro::SearchAbandoned do
  describe 'it searches abandoned transactions' do
    let(:options) { { starts_at: Time.now, ends_at: Time.now, page: 1, per_page: 10 } }
    let(:search) { PagSeguro::SearchAbandoned.new("transactions/abandoned", options, 1) }
    let(:source) { File.read("./spec/fixtures/transactions/search.xml") }
    let(:xml) { Nokogiri::XML(source) }
    let(:response) { double(:response, data: xml, unauthorized?: false, bad_request?: false) }

    describe 'the search abandoned' do
      before do
        FakeWeb.register_uri :get, %r[#{PagSeguro.api_url('v2/transactions/abandoned')}.*],
          body: xml
      end

      let(:transaction) { double(:transaction) }

      it 'returns an array of transactions' do
        expect(PagSeguro::Transaction).to receive(:load_from_xml).exactly(2)
          .times
          .and_return(transaction)
        expect(search.transactions).to eq([transaction, transaction])
      end

      it 'returns an array whith given credentials' do
        options_with_credentials = {
          credentials: PagSeguro::ApplicationCredentials.new('APP_ID', 'APP_KEY')
        }.merge(options)

        expect(PagSeguro::Transaction).to receive(:load_from_xml)
          .exactly(2)
          .times
          .and_return(transaction)

        expect(
          PagSeguro::SearchAbandoned.new('transactions/abandoned', options_with_credentials, 1).transactions
        ).to eq([transaction, transaction])
      end
    end
  end
end
