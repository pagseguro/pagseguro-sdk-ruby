module PagSeguro
  class TransactionCancellation
    include Extensions::MassAssignment

    # Set the transaction code.
    # The transaction status must be: Aguardando pagamento or Em análise.
    attr_accessor :transaction_code

    # Calls the PagSeguro webservice and register the cancellation.
    def register
      params = Serializer.new(self).to_params
      Response.new(Request.post("transactions/cancels", api_version, params))
    end

    private
    def api_version
      "v2"
    end
  end
end
