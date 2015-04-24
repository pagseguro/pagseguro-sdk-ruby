module PagSeguro
  class Authorization
    class Response
      extend Forwardable

      def_delegators :response, :success?
      attr_reader :response

      def initialize(response)
        @response = response
      end

      def errors
        @errors = response
      end

      def code
        @code ||= response.data.css("authorizationRequest > code").text if success?
      end

      def url
        PagSeguro.api_url("authorization/request.jhtml?code=#{code}") if code
      end

      def created_at
        @created_at ||= Time.parse(response.data.css("authorizationRequest > date").text) if success?
      end
    end
  end
end
