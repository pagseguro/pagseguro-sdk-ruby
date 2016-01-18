module PagSeguro
  class Company
    include Extensions::MassAssignment
    include Extensions::EnsureType

    attr_accessor :name
    attr_accessor :display_name
    attr_accessor :website_url

    attr_reader :address
    attr_reader :partner

    def address=(address)
      @address = ensure_type(Address, address)
    end

    def partner=(partner)
      @partner = ensure_type(Partner, partner)
    end

    def phones
      @phones ||= Phones.new
    end

    def phones=(_phones=[])
      _phones.each do |phone|
        phones << ensure_type(Phone, phone)
      end
    end

    def documents
      @documents ||= Documents.new
    end

    def documents=(_documents=[])
      _documents.each do |document|
        documents << ensure_type(Document, document)
      end
    end
  end
end
