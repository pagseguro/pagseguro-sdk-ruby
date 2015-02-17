module PagSeguro
  class PreApprovalRequest
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
        PagSeguro.site_url("pre-approvals/request.html?code=#{code}") if code
      end

      def code
        @code ||= response.data.css("preApprovalRequest > code").text if success?
      end

      def created_at
        @created_at ||= Time.parse(response.data.css("preApprovalRequest > date").text) if success?
      end
    end
  end
end
