module PagSeguro
  class Authorization
    class Response
      def initialize(response)
        @response = response
      end

      def serialize
        if success?
          xml = Nokogiri::XML(response.body).css('authorization').first
          ResponseSerializer.new(xml).serialize
        else
          { errors: Errors.new(response) }
        end
      end

      def serialize_collection
        if success?
          { authorizations: serialize_authorizations }
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

      def serialize_authorizations
        Nokogiri::XML(response.body).css('authorizations > authorization').map do |node|
          ResponseSerializer.new(node).serialize
        end
      end
    end
  end
end
