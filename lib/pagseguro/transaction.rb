module PagSeguro
  class Transaction
    # Find a transaction by its code.
    # Return a PagSeguro::Transaction instance.
    def self.find_by_code(code)
      load_from_response Request.get("transactions/notifications/#{code}")
    end

    # Serialize the HTTP response into data.
    def self.load_from_response(response) # :nodoc:
      new Serializer.new(response).serialize
    end

    # Initialize a new PagSeguro::Transaction instance with a Hash that
    # contains all transaction data.
    def initialize(data)

    end
  end
end
