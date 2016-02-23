module PagSeguro
  class Items
    include Extensions::CollectionObject

    # Overriding standard method to add new objects
    def <<(item)
      item = ensure_type(Item, item)

      original_item = find_item(item)

      if original_item
        original_item.quantity += (item.quantity || 1)
      else
        store << item
      end
    end

    private
    def find_item(item)
      store.detect {|stored_item| stored_item == item }
    end
  end
end
