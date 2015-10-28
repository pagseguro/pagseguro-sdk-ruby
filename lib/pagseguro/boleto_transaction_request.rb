module PagSeguro
  class BoletoTransactionRequest < TransactionRequest
    # Get the payment_method.
    def payment_method
      "boleto"
    end
  end
end
