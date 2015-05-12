require 'spec_helper'

describe PagSeguro::SearchByReference do
  describe 'it searches transactions by reference' do
    let(:options) { { reference: "ref1234" } }
    let(:search) { PagSeguro::SearchByReference.new("transactions", options, 1) }
    let(:source) { File.read("./spec/fixtures/transactions/search.xml") }
    let(:xml) { Nokogiri::XML(source) }
    let(:response) { double(:response, data: xml, unauthorized?: false, bad_request?: false) }

    describe 'the search by reference' do
      before do
        FakeWeb.register_uri :get, %r[#{PagSeguro.api_url('v3/transactions')}.*], body: xml
      end

      let(:transaction) { double(:transaction) }

      it 'returns an array of transactions' do
        expect(PagSeguro::Transaction).to receive(:load_from_xml).exactly(2)
          .times
          .and_return(transaction)
        expect(search.transactions).to eq([transaction, transaction])
      end
    end
  end
end
