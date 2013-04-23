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

      if include?(item)
        item.quantity += 1
      else
        @store << item
      end
    end

    def include?(item)
      @store.find {|stored_item| stored_item.id == ensure_type(Item, item).id }
    end
  end
end
