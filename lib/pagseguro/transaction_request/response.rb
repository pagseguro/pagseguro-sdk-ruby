module PagSeguro
  class TransactionRequest
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

      def code
        @code ||= response.data.css("transaction > code").text if success?
      end

      def created_at
        @created_at ||= Time.parse(response.data.css("transaction > date").text) if success?
      end

      def payment_link
        @payment_link ||= response.data.css("transaction > paymentLink").text if success?
      end
    end
  end
end
