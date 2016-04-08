module PagSeguro
  class Sender
    include Extensions::MassAssignment
    include Extensions::EnsureType

    # Get the sender phone.
    attr_reader :phone

    # Get the sender document
    attr_reader :document

    # Get the sender address
    attr_reader :address

    # Set the sender name.
    attr_accessor :name

    # Set the sender e-mail.
    attr_accessor :email

    # Set the sender ip
    attr_accessor :ip

    # Set sender hash.
    # It's used to identify the sender.
    attr_accessor :hash

    # Set the sender phone.
    def phone=(phone)
      @phone = ensure_type(Phone, phone)
    end

    def documents
      @documents ||= Documents.new
    end

    def documents=(_documents=[])
      _documents.each do |document|
        documents << document
      end
    end

    # Set the sender document.
    def document=(document)
      documents << ensure_type(Document, document)
    end

    # Set the sender address.
    def address=(address)
      @address = ensure_type(Address, address)
    end
  end
end
