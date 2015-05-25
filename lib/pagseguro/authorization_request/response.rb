module PagSeguro
  class AuthorizationRequest
    class Response
      def initialize(response)
        @response = response
      end

      def serialize
        if response.success? && response.xml?
          xml = Nokogiri::XML(response.body).css('authorizationRequest').first
          ResponseSerializer.new(xml).serialize
        else
          { errors: Errors.new(response) }
        end
      end

      def success?
        (response.success? && response.xml?) ? true : false
      end

      private
      # The request response.
      attr_reader :response
    end
  end
end
