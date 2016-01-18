module PagSeguro
  class Documents
    extend Forwardable
    include Enumerable
    include Extensions::EnsureType

    def_delegators :@store, :size, :clear, :empty?, :any?, :each

    def initialize
      @store = []
    end

    # Adds a new document to document list.
    def <<(document)
      document = ensure_type(Document, document)
      @store << document unless include?(document)
    end

    # Verify if the document is already included to document list.
    # Returns boolean.
    def include?(document)
      @store.detect do |stored_document|
        stored_document.type == document.type && stored_document.value == document.value
      end
    end
  end
end
