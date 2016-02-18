require 'spec_helper'

describe PagSeguro::Extensions::CollectionObject do
  before(:all) do
    # Collection
    class MyItems
      include PagSeguro::Extensions::CollectionObject
    end

    # Item
    class MyItem
      attr_accessor :name

      def ==(other)
        name.eql?(other.name)
      end
    end
  end

  let(:collection) do
    MyItems.new
  end

  let(:object) do
    item = MyItem.new
    item.name = 'Item1'
    item
  end

  context "when was included in a new class" do
    it "new class must be include PagSeguro::Extensions::CollectionObject" do
      expect(MyItems.included_modules).to include(PagSeguro::Extensions::CollectionObject)
    end

    context "and when this class is instantiated" do
      it "must be initialized empty" do
        expect(collection).to be_empty
      end

      context "must respond to" do
        [
          :size,
          :clear,
          :empty?,
          :any?,
          :each,
          :include?,
          :<<
        ].each do |method|
          it "#{method}" do
            expect(collection).to respond_to(method)
          end
        end
      end

      it "object type must be the class name singularized" do
        expect(collection.collection_type).to eq MyItem
      end
    end
  end

  context 'collection operations' do
    it "when add a new object it must be incremented" do
      expect{ collection << object }.to change{ collection.size }.by(1)
    end

    it "when add an object already added" do
      collection << object
      expect{ collection << object }.to_not change{ collection.size }
    end

    it "must to include an object before added" do
      collection << object
      expect(collection).to include(object)
    end
  end
end
