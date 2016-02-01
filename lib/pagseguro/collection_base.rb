module PagSeguro
  class CollectionBase
    extend CollectionManagers::MacroMethods
    extend Forwardable
    include Enumerable

    def_delegators :@store, :size, :clear, :empty?, :any?, :each, :include?

    def initialize
      @store = []
    end

    def collection_manager
      CollectionManagers::GenericManager
    end

    def collection_type
      eval singularize(self.class.to_s)
    end

    # Adds a new object to the collection.
    def <<(param)
      manager = collection_manager.new(collection_type)
      manager.add(@store, param)
    end

    private

    def singularize(string)
      string.chars.to_a.slice(0...-1).join if string[-1] == 's'
    end
  end
end
