module PagSeguro
  class PaymentRelease
    include Extensions::MassAssignment
    include Extensions::EnsureType

    # Set the number of installments
    attr_accessor :installment

    # Set the total amount
    attr_accessor :total_amount

    # Set the total amount of the current release
    attr_accessor :release_amount

    # Set the status of current release
    attr_accessor :status

    # Set the release date
    attr_accessor :release_date
  end
end
