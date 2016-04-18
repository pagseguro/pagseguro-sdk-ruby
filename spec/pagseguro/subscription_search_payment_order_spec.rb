require 'spec_helper'

describe PagSeguro::SubscriptionSearchPaymentOrders do
  let(:credentials) { PagSeguro::AccountCredentials.new('user@example.com', 'TOKEN') }
  let(:status) { :not_processed }
  let(:code) { '12345' }

  let(:options) { {credentials: credentials} }

  subject { described_class.new(code, status, options) }

  context 'when search succeeds' do
    before do
      FakeWeb.register_uri(
        :get,
        'https://ws.pagseguro.uol.com.br/pre-approvals/12345/payment-orders?status=3&page=1&email=user%40example.com&token=TOKEN&charset=UTF-8',
        content_type: 'text/xml',
        status: 200,
        body: data
      )

      subject.next_page!
    end

    let(:data) { File.read('./spec/fixtures/subscription_search_payment_orders/success.xml') }

    it 'must have results in page' do
      expect(subject.results).to eq 2
    end

    it 'must have total pages' do
      expect(subject.total_pages).to eq 1
    end

    it 'must have date of create' do
      expect(subject.created_at).to eq Time.new(2016, 3, 30, 18, 59, 53, '-03:00')
    end

    context '#payment_orders' do
      it 'must return a array of SubscriptionPaymentOrder' do
        expect(subject.payment_orders).to be_an Array

        subject.payment_orders.each do |payment_order|
          expect(payment_order).to be_a PagSeguro::SubscriptionPaymentOrder
        end
      end

      context 'payment order object' do
        let(:order) { subject.payment_orders.first }

        it { expect(order.code).to eq 'D2579C9461BA45F880419FE535763EFE' }
        it { expect(order.status).to eq :paid }
        it { expect(order.amount).to eq '80.00' }
        it { expect(order.gross_amount).to eq '230' }
        it { expect(order.last_event_date).to eq Time.new(2016,3,30,0,50,11, '-03:00') }
        it { expect(order.discount.type).to eq 'DISCOUNT_PERCENT' }
        it { expect(order.discount.value).to eq '0' }
        it { expect(order.scheduling_date).to eq Time.new(2016,4,14,15,14,29, '-03:00') }
        it { expect(order.transactions.first.code).to eq 'DBFABA621D734DCDA471F592E964A39E' }
        it { expect(order.transactions.first.date).to eq Time.new(2016,3,30,0,48,49, '-03:00') }
        it { expect(order.transactions.first.status).to eq :paid }
      end
    end
  end

  context 'when search fails' do
    before do
      FakeWeb.register_uri(
        :get,
        'https://ws.pagseguro.uol.com.br/pre-approvals/12345/payment-orders?status=3&page=1&email=user%40example.com&token=TOKEN&charset=UTF-8',
        content_type: 'text/xml',
        status: 400
      )

      subject.next_page!
    end

    it 'must do not be valid' do
      expect(subject).to_not be_valid
    end

    it 'errors cannot be empty' do
      expect{ subject.valid? }.to change{ subject.errors.empty? }.to false
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
