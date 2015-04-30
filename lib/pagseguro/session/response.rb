module PagSeguro
  class Session
    class Response
      extend Forwardable

      def_delegators :response, :success?

      # The request response.
      attr_reader :response

      def initialize(response)
        @response = response
      end

      def errors
        @errors ||= Errors.new(response)
      end
    end
  end
end
