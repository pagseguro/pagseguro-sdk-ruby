require 'spec_helper'

describe PagSeguro::Subscription::ResponseSerializer do
  subject { PagSeguro::Subscription::ResponseSerializer.new(xml) }

  let(:xml) { Nokogiri::XML(source) }

  context 'serializer from normal response' do
    let(:source) { File.read('./spec/fixtures/subscription/success.xml') }

    it 'must return the code' do
      expect(subject.serialize).to eq({code: '12345'})
    end
  end

  context 'serializer from a find response' do
    let(:source) { File.read('./spec/fixtures/subscription/find_success.xml') }

    context 'must a hash with the serialized attributes' do
      let(:data) { subject.serialize_from_search }

      it { expect(data[:name]).to eq 'Seguro contra roubo do Notebook Prata' }
      it { expect(data[:code]).to eq 'C08984179E9EDF3DD4023F87B71DE349' }
      it { expect(data[:date]).to eq '2011-11-23T13:40:23.000-02:00' }
      it { expect(data[:tracker]).to eq '538C53' }
      it { expect(data[:status]).to eq 'CANCELLED' }
      it { expect(data[:reference]).to eq 'REF1234' }
      it { expect(data[:status]).to eq 'CANCELLED' }
      it { expect(data[:last_event_date]).to eq '2011-11-25T20:04:23.000-02:00' }
      it { expect(data[:charge]).to eq 'auto' }
      it { expect(data[:last_event_date]).to eq '2011-11-25T20:04:23.000-02:00' }
      it { expect(data[:sender][:name]).to eq 'Comprador Istambul' }
      it { expect(data[:sender][:email]).to eq 'c@i.com' }
      it { expect(data[:sender][:phone][:area_code]).to eq '11' }
      it { expect(data[:sender][:phone][:number]).to eq '30389678' }
      it { expect(data[:sender][:address][:street]).to eq 'ALAMEDA ITU' }
      it { expect(data[:sender][:address][:number]).to eq '78' }
      it { expect(data[:sender][:address][:complement]).to eq 'ap. 2601' }
      it { expect(data[:sender][:address][:district]).to eq 'Jardim Paulista' }
      it { expect(data[:sender][:address][:city]).to eq 'SAO PAULO' }
      it { expect(data[:sender][:address][:state]).to eq 'SP' }
      it { expect(data[:sender][:address][:country]).to eq 'BRASIL' }
      it { expect(data[:sender][:address][:postal_code]).to eq '01421000' }
    end
  end
end
