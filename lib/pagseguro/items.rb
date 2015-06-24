module PagSeguro
  class Items
    extend Forwardable
    include Enumerable
    include Extensions::EnsureType

    def_delegators :@store, :size, :clear, :empty?, :any?, :each

    def initialize
      @store = []
    end

    def <<(item)
      item = ensure_type(Item, item)

      original_item = include?(item)

      if original_item
        original_item.quantity += 1
      else
        @store << item
      end
    end

    def include?(item)
      @store.detect do |stored_item|
        stored_item.id == item.id && stored_item.description == item.description
      end
    end
  end
end
