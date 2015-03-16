module PagSeguro
  class Transaction
    class Response
      # The response errors.
      attr_reader :errors

      def initialize(errors = Errors.new)
        @errors = errors
      end
    end
  end
end
