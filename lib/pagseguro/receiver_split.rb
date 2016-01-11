module PagSeguro
  class ReceiverSplit
    include Extensions::MassAssignment
    include Extensions::EnsureType

    # Set amount.
    attr_accessor :amount

    # Set rate percent.
    attr_accessor :rate_percent

    # Set fee percent.
    attr_accessor :fee_percent
  end
end
