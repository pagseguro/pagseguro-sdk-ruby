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

    # Set the sender phone.
    def phone=(phone)
      @phone = ensure_type(Phone, phone)
    end
  end
end
