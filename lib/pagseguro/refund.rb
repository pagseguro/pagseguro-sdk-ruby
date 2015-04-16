module PagSeguro
  class Refund
    include Extensions::MassAssignment

    # Set the transaction code.
    # The transaction status must be: Paga (3), Disponível (4), Em disputa (5)
    attr_accessor :transaction_code

    # Calls the PagSeguro webservice and register the refund.
    def register
      params = Serializer.new(self).to_params
      Response.new(Request.post('transactions/refunds', api_version, params))
    end

    private
    def api_version
      'v2'
    end
  end
end
