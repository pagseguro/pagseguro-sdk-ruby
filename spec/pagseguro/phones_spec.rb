require 'spec_helper'

RSpec.describe PagSeguro::Phones do
  [
    :size,
    :clear,
    :empty?,
    :any?,
    :each,
    :map
  ].each do |method|
    it { is_expected.to respond_to(method) }
  end

  it 'should initialize empty' do
    expect(subject).to be_empty
  end

  context 'adding a new phone' do
    let(:phone) { { type: 'HOME', area_code: 11, number: 11112222 } }

    it "shouldn't add the same phone" do
      subject << phone
      expect{ subject << phone }.to_not change{ subject.size }
    end

    context 'ensures type the new phone' do
      it 'can be a hash' do
        expect{ subject << phone }.to change{ subject.size }.to(1)
      end

      it 'can be a PagSeguro::Phone' do
        phone = PagSeguro::Phone.new(type: 'MOBILE', area_code: 11, number: 22221111)
        expect{ subject << phone }.to change{ subject.size }.to(1)
      end
    end
  end
end
