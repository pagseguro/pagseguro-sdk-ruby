module PagSeguro
  class Session
    class Response
      def initialize(response, session)
        @response = response
        @session = session
      end

      def serialize
        if success?
          xml = Nokogiri::XML(response.body).css("session").first
          session.update_attributes(ResponseSerializer.new(xml).serialize)
        else
          session.errors.add(response)
        end

        session
      end

      def success?
        response.success? && response.xml?
      end

      private
      # The request response.
      attr_reader :response

      # The Session instance.
      attr_reader :session
    end
  end
end
