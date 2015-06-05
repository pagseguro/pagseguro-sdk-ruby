module PagSeguro
  class Refund
    include Extensions::MassAssignment

    # Set the transaction code.
    # The transaction status must be: Paga (3), Disponível (4), Em disputa (5)
    attr_accessor :transaction_code

    # Set the refund value.
    # Greater than 0.00 and less or equal than transaction value.
    # If not informed, PagSeguro will assume the total transaction value.
    attr_accessor :value

    # Calls the PagSeguro webservice and register the refund.
    # Return boolean.
    def register
      Response.new(Request.post("transactions/refunds", api_version, params))
    end

    private
    def api_version
      "v2"
    end

    def params
      RequestSerializer.new(self).to_params
    end
  end
end
