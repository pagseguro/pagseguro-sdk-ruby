module PagSeguro
  module CollectionManagers
    class ItemsManager
      include Extensions::EnsureType

      def initialize(collection_type)
        @collection_type = collection_type
      end

      def add(store, param)
        item = ensure_type(@collection_type, param)

        original_item = include?(store, item)

        if original_item
          if item.quantity.nil?
            original_item.quantity += 1
          else
            original_item.quantity += item.quantity
          end
        else
          store << item
        end
      end

      private

      def include?(store, object)
        store.detect { |stored_object| stored_object == object }
      end
    end
  end
end
