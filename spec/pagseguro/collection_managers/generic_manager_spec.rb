require 'spec_helper'

describe PagSeguro::CollectionManagers::GenericManager do
  let(:collection_type) { PagSeguro::Phone }
  let(:object_params) { {type: 'HOME', area_code: '11', number: '33114562'} }
  let(:object) { PagSeguro::Phone.new(object_params) }
  let(:store) { [] }

  subject { described_class.new(collection_type) }

  context 'when add object in collection' do
    context 'ensures the object is kind of collection type' do
      it 'when an object is given' do
        subject.add(store, object)
        expect(store.last).to be_a collection_type
      end

      it 'when an object params is given' do
        subject.add(store, object_params)
        expect(store.last).to be_a collection_type
      end
    end

    it 'cannot include the same object' do
      subject.add(store, object)
      subject.add(store, object_params)

      expect(store.size).to eq 1
      expect(store.last).to eq object
    end
  end

  it 'includes Extensions::EnsureType' do
    expect(described_class.included_modules).to include PagSeguro::Extensions::EnsureType
  end
end
