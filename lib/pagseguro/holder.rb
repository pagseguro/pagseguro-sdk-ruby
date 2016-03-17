module PagSeguro
  class Holder
    include Extensions::MassAssignment
    include Extensions::EnsureType

    # Set the name.
    attr_accessor :name

    # Set the birth date.
    attr_accessor :birth_date

    # Get document info.
    attr_reader :document

    # Get the phone.
    attr_reader :phone

    # Get the billing address
    attr_reader :billing_address

    # Set the document.
    def document=(document)
      @document = ensure_type(Document, document)
    end

    # Set the phone.
    def phone=(phone)
      @phone = ensure_type(Phone, phone)
    end

    # Set the billing address
    def billing_address=(billing_address)
      @billing_address = ensure_type(Address, billing_address)
    end
  end
end
