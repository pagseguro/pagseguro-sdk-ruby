module PagSeguro
  class Session
    class Response
      # The response errors.
      attr_reader :errors

      def initialize(errors = Errors.new)
        @errors = errors
      end
    end
  end
end
