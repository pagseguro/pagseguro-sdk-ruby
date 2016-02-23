require 'spec_helper'

describe PagSeguro::Search do
  let(:search) { PagSeguro::Search.new("foo", "bar", 1) }
  let(:source) { File.read("./spec/fixtures/transactions/search.xml") }
  let(:xml) { Nokogiri::XML(source) }
  let(:response) do
    double(
      :response,
      data: xml,
      error?: false,
      error: nil
    )
  end

  context 'when being initialized' do
    it 'initializes with passed page number' do
      search = PagSeguro::Search.new('/foo/bar', 'options', 1)
      expect(search.page).to eq(1)
    end

    it 'initializes with default page number' do
      search = PagSeguro::Search.new('/foo/bar', 'options')
      expect(search.page).to eq(0)
    end
  end

  describe 'methods that parse xml' do
    before do
      search.instance_exec(response) do |response|
        @response = response
        @errors = PagSeguro::Errors.new(response)
      end

      allow(search).to receive(:perform_request_and_serialize)
    end

    describe '#transactions' do
      it 'returns an array of transactions' do
        expect(search.transactions.size).to eq(2)
      end
    end

    describe '#created_at' do
      it 'returns the created date' do
        expect(search.created_at).to eq(Time.parse("2011-02-16T20:14:35.000-02:00"))
      end
    end

    describe '#results' do
      it 'returns the number of results' do
        expect(search.results).to eq(10)
      end
    end

    describe '#total_pages' do
      it 'returns the number of pages' do
        expect(search.total_pages).to eq(1)
      end
    end
  end

  describe '#next_page?' do
    context 'when there is a next page' do
      search = PagSeguro::Search.new('foo', 'bar', 0)
      it 'is page 0' do
        expect(search).to be_next_page
      end

      it 'is not page 0, but page < total_pages' do
        allow(search).to receive(:total_pages).and_return(3)
        expect(search).to be_next_page
      end
    end

    context 'when there is no next page' do
      it 'is not page 0, but page == total_pages' do
        allow(search).to receive(:total_pages).and_return(1)
        expect(search).not_to be_next_page
      end
    end
  end

  describe '#previous_page?' do
    context 'when there is a previous page' do
      search = PagSeguro::Search.new('foo', 'bar', 2)
      it { expect(search).to be_previous_page }
    end

    context 'when there is no previous page' do
      it { expect(search).not_to be_previous_page }
    end
  end

  describe '#next_page!' do
    it 'has next page' do
      allow(search).to receive(:next_page?).and_return(true)
      search.next_page!
      expect(search.page).to eq(2)
    end

    it "doesn't have next page" do
      allow(search).to receive(:next_page?).and_return(false)
      search.next_page!
      expect(search.page).to eq(1)
    end
  end

  describe '#previous_page!' do
    it 'has previous page' do
      search = PagSeguro::Search.new("foo", "bar", 2)
      search.previous_page!
      expect(search.page).to eq(1)
    end

    it "does't have previous page" do
      search.previous_page!
      expect(search.page).to eq(1)
    end
  end

  describe '#valid?' do
    it 'is valid' do
      allow(search).to receive(:fetch).and_return(true)
      expect(search).to be_valid
    end

    it "isn't valid" do
      allow(search).to receive(:fetch).and_return(false)
      expect(search).not_to be_valid
    end
  end
end
