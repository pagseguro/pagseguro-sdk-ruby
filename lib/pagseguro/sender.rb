module PagSeguro
  class Sender
    include Extensions::MassAssignment
    include Extensions::EnsureType

    # Get the sender phone.
    attr_reader :phone

    # Get the sender document
    attr_reader :document

    # Set the sender name.
    attr_accessor :name

    # Set the sender e-mail.
    attr_accessor :email

    # Set the CPF document.
    attr_accessor :cpf

    # Set the sender phone.
    def phone=(phone)
      @phone = ensure_type(Phone, phone)
    end

    # Set the sender document.
    def document=(document)
      @document = ensure_type(Document, document)
    end
  end
end
