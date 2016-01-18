module PagSeguro
  class Account
    include Extensions::MassAssignment
    include Extensions::EnsureType

    # Set the account e-mail.
    attr_accessor :email

    # Set the account type.
    # Must be PERSONAL, SELLER or COMPANY.
    attr_accessor :type

    # Get the person account.
    attr_reader :person

    # Get the company account.
    attr_reader :company

    def person=(person)
      return if company
      @person = ensure_type(Person, person)
    end

    def company=(company)
      return if person
      @company = ensure_type(Company, company)
    end
  end
end
