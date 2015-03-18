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

    # Set sender hash.
    # It's used to identify the sender.
    attr_accessor :hash

    # Set the sender phone.
    def phone=(phone)
      @phone = ensure_type(Phone, phone)
    end
  end
end
