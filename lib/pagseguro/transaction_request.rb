module PagSeguro
  class TransactionRequest
    include Extensions::MassAssignment
    include Extensions::EnsureType

    # Set the payment currency.
    # Defaults to BRL.
    attr_accessor :currency

    private
    def before_initialize
      self.currency = "BRL"
    end
  end
end
