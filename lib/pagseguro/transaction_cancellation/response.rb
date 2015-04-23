module PagSeguro
  class TransactionCancellation
    class Response
      extend Forwardable

      def_delegators :response, :success?
      attr_reader :response

      def initialize(response)
        @response = response
      end

      def errors
        @errors ||= Errors.new(response)
      end

      def result
        @result ||= response.data.css("result").text if success?
      end
    end
  end
end
