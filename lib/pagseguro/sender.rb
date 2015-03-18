module PagSeguro
  class Sender
    include Extensions::MassAssignment
    include Extensions::EnsureType

    # Get the sender phone.
    attr_reader :phone

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

    # Hold the sender's documents.
    def documents
      @documents ||= Documents.new
    end

    # Normalize the documents list.
    def documents=(_documents)
      _documents.each { |document| documents << document }
    end
  end
end
