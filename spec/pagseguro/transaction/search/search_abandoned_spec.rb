require 'spec_helper'

describe PagSeguro::SearchAbandoned do
  subject do
    PagSeguro::SearchAbandoned.new("transactions/abandoned", options, 1)
  end

  let(:source) { File.read("./spec/fixtures/transactions/search.xml") }
  let(:body) { Nokogiri::XML(source) }

  describe 'it searches abandoned transactions' do
    before do
      FakeWeb.register_uri :get,
        %r{https://ws.pagseguro.uol.com.br/v2/transactions/abandoned.*finalDate=2015-11-12T16%3A59.*initialDate=2015-11-12T15%3A34.*page=1},
        body: body
    end

    let(:options) do
      {
        starts_at: Time.new(2015, 11, 12, 15, 34),
        ends_at: Time.new(2015, 11, 12, 16, 59),
        page: 1,
        per_page: 10
      }
    end

    describe 'the search abandoned' do
      it 'returns an array of transactions' do
        expect(subject.transactions.size).to eq(2)
      end
    end
  end

  describe 'it searches abandoned transactions using credentials' do
    before do
      FakeWeb.register_uri :get,
        %r{https://ws.pagseguro.uol.com.br/v2/transactions/abandoned.*appId=APP_ID.*appKey=APP_KEY.*finalDate=2015-11-12T16%3A59.*initialDate=2015-11-12T15%3A34.*},
        body: body
    end

    let(:options) do
      {
        starts_at: Time.new(2015, 11, 12, 15, 34),
        ends_at: Time.new(2015, 11, 12, 16, 59),
        page: 1,
        per_page: 10,
        credentials: PagSeguro::ApplicationCredentials.new('APP_ID', 'APP_KEY')
      }
    end

    it 'returns an array with given credentials' do
      expect(subject.transactions.size).to eq(2)
    end
  end
end
