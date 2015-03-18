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

    # Set the document.
    def document=(document)
      @document = ensure_type(Document, document)
    end

    # Set the phone.
    def phone=(phone)
      @phone = ensure_type(Phone, phone)
    end
  end
end
