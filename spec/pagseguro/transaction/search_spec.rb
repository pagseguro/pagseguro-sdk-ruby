require 'spec_helper'

describe PagSeguro::Search do
  let(:search) { PagSeguro::Search.new("foo", "bar", 1) }
  let(:source) { File.read("./spec/fixtures/transactions/search.xml") }
  let(:xml) { Nokogiri::XML(source) }

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

  describe '#transactions' do
    it 'returns a transaction search results' do
      allow(search).to receive(:xml).and_return(xml)
    end
  end

  describe '#created_at' do
    xit 'returns the created date' do
      allow(search).to receive(:xml).and_return(xml)
      expect(search.created_at).to eq(Time.parse("2011-02-16T20:14:35.000-02:00"))
    end
  end

  describe '#results' do
    xit 'returns the number of results' do
      allow(search).to receive(:xml).and_return(xml)
      expect(search.results).to eq("10")
    end
  end

  describe '#total_pages' do
    xit 'returns the number of pages' do
      allow(search).to receive(:xml).and_return(xml)
      expect(search.total_pages).to eq("1")
    end
  end

  describe '#next_page?' do
    context 'when there is a next page' do
      search = PagSeguro::Search.new('foo', 'bar', 0)
      it 'is page 0' do
        expect(search.next_page?).to be_truthy
      end

      it 'is not page 0, but page < total_pages' do
        allow(search).to receive(:total_pages).and_return(3)
        expect(search.next_page?).to be_truthy
      end
    end

    context 'when there is no next page' do
      it 'is not page 0, but page == total_pages' do
        allow(search).to receive(:total_pages).and_return(1)
        expect(search.next_page?).to be_falsy
      end
    end
  end

  describe '#previous_page?' do
    context 'when there is a previous page' do
      search = PagSeguro::Search.new('foo', 'bar', 2)
      it { expect(search.previous_page?).to be_truthy }
    end

    context 'when there is no previous page' do
      it { expect(search.previous_page?).to be_falsy }
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
      expect(search.valid?).to be_truthy
    end

    it "isn't valid" do
      allow(search).to receive(:fetch).and_return(false)
      expect(search.valid?).to be_falsy
    end
  end
end
