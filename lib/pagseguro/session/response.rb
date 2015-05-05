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

      def parse
        # if response.success? and response.xml?
        #   xml = Nokogiri::XML(response.body).css("session").first
        #   Serializer.new(xml).serialize
        # end

        self
      end
    end
  end
end
