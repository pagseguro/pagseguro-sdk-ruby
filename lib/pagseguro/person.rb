module PagSeguro
  class Person
    include Extensions::MassAssignment
    include Extensions::EnsureType

    # Set the account name.
    attr_accessor :name

    # Set the account birth_date.
    # Pattern: aaaa-MM-dd
    attr_accessor :birth_date

    # Set the account address.
    attr_reader :address

    def address=(address)
      @address = ensure_type(Address, address)
    end

    def documents
      @documents ||= Documents.new
    end

    def documents=(_documents=[])
      _documents.each do |document|
        documents << ensure_type(Document, document)
      end
    end

    def phones
      @phones ||= Phones.new
    end

    def phones=(_phones=[])
      _phones.each do |phone|
        phones << ensure_type(Phone, phone)
      end
    end
  end
end
