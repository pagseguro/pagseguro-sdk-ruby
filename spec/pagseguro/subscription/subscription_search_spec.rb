require 'spec_helper'

describe PagSeguro::SubscriptionSearch do
  let(:path) { 'path-to-search' }
  let(:credentials) { PagSeguro::AccountCredentials.new('user@example.com', 'TOKEN') }
  let(:options) do
    {
      credentials: credentials
    }
  end

  subject { PagSeguro::SubscriptionSearch.new(path, options) }

  context 'when search succeeds' do
    before do
      FakeWeb.register_uri(
        :get,
        "https://ws.pagseguro.uol.com.br/v2/path-to-search?page=1&email=user%40example.com&token=TOKEN&charset=UTF-8",
        body: response_body,
        content_type: "text/xml"
      )

      subject.next_page!
    end

    let(:response_body) { File.read('./spec/fixtures/subscription/search_success.xml') }

    it 'must have results in page' do
      expect(subject.results).to eq 1
    end

    it 'must have total pages' do
      expect(subject.total_pages).to eq 1
    end

    it 'must have date of create' do
      expect(subject.created_at).to eq Time.new(2011,8,8,16,16,23, '-03:00')
    end

    context 'subscriptions' do
      it 'must return a subscription array' do
        expect(subject.subscriptions).to be_an Array

        subject.subscriptions.each do |subscription|
          expect(subscription).to be_a PagSeguro::Subscription
        end
      end

      context 'subscription' do
        let(:subscription) { subject.subscriptions.first }

        it 'must have name' do
          expect(subscription.name).to eq 'PagSeguro Pre Approval'
        end

        it 'must have code' do
          expect(subscription.code).to eq '12E10BEF5E5EF94004313FB891C8E4CF'
        end

        it 'must have date' do
          expect(subscription.date).to eq "2011-08-15T11:06:44.000-03:00"
        end

        it 'must have tracker' do
          expect(subscription.tracker).to eq '624C17'
        end

        it 'must have status' do
          expect(subscription.status).to eq 'INITIATED'
        end

        it 'must have reference' do
          expect(subscription.reference).to eq 'R123456'
        end

        it 'must have last event date' do
          expect(subscription.last_event_date).to eq "2011-08-08T15:37:30.000-03:00"
        end

        it 'must have charge' do
          expect(subscription.charge).to eq 'auto'
        end
      end
    end
  end

  context 'when search fails' do
    before do
      FakeWeb.register_uri(
        :get,
        "https://ws.pagseguro.uol.com.br/v2/path-to-search?page=1&email=user%40example.com&token=TOKEN&charset=UTF-8",
        body: response_body,
        status: ['400', 'ERROR'],
        content_type: "text/xml"
      )

      subject.next_page!
    end

    let(:response_body) { File.read('./spec/fixtures/subscription/fail.xml') }

    it 'must do not be valid' do
      expect(subject).to_not be_valid
    end

    it 'errors must not be empty' do
      expect{ subject.valid? }.to change{ subject.errors.empty? }
    end
  end

  context 'page control' do
    it 'page default should be 1' do
      expect(subject.page).to eq 0
    end

    it 'search can begin with other page' do
      options[:page] = 2
      expect(subject.page).to eq 2
    end

    context 'next page' do
      it 'should increment the page by 1' do
        allow(subject).to receive(:total_pages).and_return(10)
        expect{ subject.next_page! }.to change{ subject.page }.from(0).to(1)
      end

      it 'not increment if no have more pages' do
        subject.next_page!
        allow(subject).to receive(:total_pages).and_return(1)
        expect{ subject.next_page! }.to_not change{ subject.page }
      end
    end

    context 'previous page' do
      it 'should decrement the page by 1' do
        options[:page] = 3
        expect{ subject.previous_page! }.to change{ subject.page }.from(3).to(2)
      end

      it 'not decrement unless current page be more than 1' do
        expect{ subject.previous_page! }.not_to change{ subject.page }
      end
    end

    context 'when page changes' do
      it 'fetched clear! should be called' do
        allow(subject).to receive(:total_pages).and_return(10)
        expect(subject).to receive(:clear!).with(no_args)
        subject.next_page!
      end
    end
  end
end

