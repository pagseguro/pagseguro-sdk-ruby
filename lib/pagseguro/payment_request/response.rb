module PagSeguro
  class PaymentRequest
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

      def url
        PagSeguro.site_url("#{api_version}/checkout/payment.html?code=#{code}") if code
      end

      def code
        @code ||= response.data.css("checkout > code").text if success?
      end

      def created_at
        @created_at ||= Time.parse(response.data.css("checkout > date").text) if success?
      end

      # Default PagSeguro API version for payments
      def api_version
        'v2'
      end
    end
  end
end
