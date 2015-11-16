require 'spec_helper'

describe PagSeguro::SearchByDate do
  subject do
    PagSeguro::SearchByDate.new("transactions", options, 1)
  end

  before do
    FakeWeb.register_uri :get,
      %r{https://ws.pagseguro.uol.com.br/v3/transactions.*finalDate=2015-11-12T16%3A59.*initialDate=2015-11-12T15%3A34.*page=1},
      body: body
  end

  let(:options) do
    {
      starts_at: Time.new(2015, 11, 12, 15, 34),
      ends_at: Time.new(2015, 11, 12, 16, 59),
      per_page: 1
    }
  end

  let(:source) { File.read("./spec/fixtures/transactions/search.xml") }
  let(:body) { Nokogiri::XML(source) }

  it 'searches transactions by date' do
    expect(subject.transactions.size).to eq(2)
  end
end
