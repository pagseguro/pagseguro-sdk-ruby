module PagSeguro
  class Documents
    include Enumerable
    extend Forwardable
    include Extensions::EnsureType

    def_delegators :@documents, :each, :size

    def initialize
      @documents = []
    end

    def <<(document)
      document = ensure_type(Document, document)

      @documents << document unless @documents.include? document
    end

    def include?(document)
      self.find do |doc|
        doc.value == ensure_type(Document,document).value
      end
    end
  end
end
