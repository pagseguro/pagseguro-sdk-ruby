require 'spec_helper'

describe PagSeguro::SubscriptionPaymentOrder::ResponseSerializer do
  let(:xml) { Nokogiri::XML(source) }
  let(:source) { File.read('./spec/fixtures/subscription_payment_order/success.xml') }

  subject { described_class.new(xml) }

  context '#serialize' do
    let(:data) { subject.serialize }

    it { expect(data[:code]).to eq 'D2579C9461BA45F880419FE535763EFE' }
    it { expect(data[:status]).to eq :paid }
    it { expect(data[:amount]).to eq '80.00' }
    it { expect(data[:gross_amount]).to eq '230' }
    it { expect(data[:last_event_date]).to eq Time.new(2016,3,30,0,50,11, '-03:00') }
    it { expect(data[:discount][:type]).to eq 'DISCOUNT_PERCENT' }
    it { expect(data[:discount][:value]).to eq '0' }
    it { expect(data[:scheduling_date]).to eq Time.new(2016,4,14,15,14,29, '-03:00') }
    it { expect(data[:transactions][0][:code]).to eq 'DBFABA621D734DCDA471F592E964A39E' }
    it { expect(data[:transactions][0][:date]).to eq Time.new(2016,3,30,0,48,49, '-03:00') }
    it { expect(data[:transactions][0][:status]).to eq :paid }
  end
end
