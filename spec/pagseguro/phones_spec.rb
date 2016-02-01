require 'spec_helper'

RSpec.describe PagSeguro::Phones do
  it_behaves_like "Collection"

  context 'adding a new phone' do
    let(:phone) { { type: 'HOME', area_code: 11, number: 11112222 } }

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
