module PagSeguro
  class OnlineDebitTransactionRequest < TransactionRequest
    # Get the bank info.
    attr_reader :bank

    # Get the payment_method.
    def payment_method
      "online_debit"
    end

    # Set the bank.
    # Required for online debit payment method.
    def bank=(bank)
      @bank = ensure_type(Bank, bank)
    end
  end
end
