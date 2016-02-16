module PagSeguro
  module CollectionManagers
    class GenericManager
      include Extensions::EnsureType

      def initialize(collection_type)
        @collection_type = collection_type
      end

      def add(store, param)
        object = ensure_type(@collection_type, param)
        store << object unless include?(store, object)
      end

      private

      def include?(store, object)
        store.detect { |stored_object| stored_object == object }
      end
    end
  end
end
