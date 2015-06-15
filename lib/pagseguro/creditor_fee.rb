module PagSeguro
  class CreditorFee
    include Extensions::MassAssignment

    # Set the current transaction intermidiation rate amount
    attr_accessor :intermediation_rate_amount

    # Set the current transaction intermediation fee amount
    attr_accessor :intermediation_fee_amount

    # Set the current transaction installment amount
    attr_accessor :installment_fee_amount

    # Set the current transaction operational fee amount
    attr_accessor :operational_fee_amount

    # Set the current transaction commission fee amount
    attr_accessor :commission_fee_amount

    # Set the current transaction freight amount
    attr_accessor :efrete
  end
end
