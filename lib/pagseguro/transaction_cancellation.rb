module PagSeguro
  class TransactionCancellation
    include Extensions::MassAssignment

    # Set the transaction code.
    # The transaction status must be: Aguardando pagamento or Em análise.
    attr_accessor :transaction_code

    def register
    end

    private
    def api_version
      "v2"
    end
  end
end
