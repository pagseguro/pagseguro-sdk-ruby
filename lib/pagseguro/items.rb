module PagSeguro
  class Items
    extend Forwardable
    include Enumerable
    include Extensions::EnsureType

    def_delegators :@store, :size, :clear, :empty?, :any?, :each

    def initialize
      @store = []
    end

    # Adds a new item to item list.
    def <<(item)
      item = ensure_type(Item, item)

      original_item = include?(item)

      if original_item
        if item.quantity.nil?
          original_item.quantity += 1
        else
          original_item.quantity += item.quantity
        end
      else
        @store << item
      end
    end

    # Verify if the item is already included to item list.
    # Returns boolean.
    def include?(item)
      @store.detect do |stored_item|
        stored_item.id == item.id && stored_item.description == item.description && stored_item.amount == item.amount
      end
    end
  end
end
