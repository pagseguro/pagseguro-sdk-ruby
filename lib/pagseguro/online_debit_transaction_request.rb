module PagSeguro
  class OnlineDebitTransactionRequest < TransactionRequest
    # Get the bank info.
    attr_reader :bank

    # Set the bank.
    # Required if payment method is online debit.
    def bank=(bank)
      @bank = ensure_type(Bank, bank)
    end
  end
end
