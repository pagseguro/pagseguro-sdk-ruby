module PagSeguro
  class BoletoTransactionRequest < TransactionRequest
    def payment_method
      "boleto"
    end
  end
end
