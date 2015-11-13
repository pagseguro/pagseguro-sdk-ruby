require 'spec_helper'

describe PagSeguro::SearchByReference do
  subject do
    PagSeguro::SearchByReference.new("transactions", options, 1)
  end

  before do
    FakeWeb.register_uri :get,
      %r{https://ws.pagseguro.uol.com.br/v3/transactions.*reference=ref1234.*},
      body: body
  end

  let(:options) { { reference: "ref1234" } }
  let(:source) { File.read("./spec/fixtures/transactions/search.xml") }
  let(:body) { Nokogiri::XML(source) }

  it 'searches transactions by reference' do
    expect(subject.transactions.size).to eq(2)
  end
end
