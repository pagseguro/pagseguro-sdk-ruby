module PagSeguro
  class Transaction
    class Response
      # Set the response errors.
      attr_reader :errors

      def initialize(errors = Errors.new)
        @errors = errors
      end
    end
  end
end
