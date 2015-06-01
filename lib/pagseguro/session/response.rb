module PagSeguro
  class Session
    class Response
      def initialize(response)
        @response = response
      end

      def serialize
        if response.success? && response.xml?
          xml = Nokogiri::XML(response.body).css("session").first
          ResponseSerializer.new(xml).serialize
        else
          { errors: Errors.new(response) }
        end
      end

      private
      # The request response.
      attr_reader :response
    end
  end
end
