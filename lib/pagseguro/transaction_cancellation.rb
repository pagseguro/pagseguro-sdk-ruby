module PagSeguro
  class TransactionCancellation
    include Extensions::MassAssignment

    # Set the transaction code.
    # The transaction status must be: Aguardando pagamento or Em análise.
    attr_accessor :transaction_code

    # Result from http request.
    attr_accessor :result

    # Calls the PagSeguro webservice and register the cancellation.
    # Return boolean.
    def register
      request = Request.post("transactions/cancels", api_version, params)
      response = Response.new(request, self)
      response.serialize

      response.success?
    end

    # Errors object.
    def errors
      @errors ||= Errors.new
    end

    def update_attributes(attrs)
      attrs.each { |name, value| send("#{name}=", value) }
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
