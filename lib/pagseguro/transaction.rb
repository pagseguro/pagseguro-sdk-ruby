module PagSeguro
  class Transaction
    # Find a transaction by its code.
    # Return a PagSeguro::Transaction instance.
    def self.find_by_code(code)
      load_from_response Request.get("transactions/notifications/#{code}")
    end

    def self.load_from_response(response)
      new Serializer.new(response).serialize
    end

    def initialize(data)

    end
  end
end
