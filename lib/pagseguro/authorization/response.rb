module PagSeguro
  class Authorization
    class Response
      def initialize(response, object)
        @response = response
        @object = object
      end

      def serialize
        if success?
          xml = Nokogiri::XML(response.body).css('authorization').first
          serializer = ResponseSerializer.new(xml).serialize
          object.update_attributes(serializer)
        else
          object.errors.add(response)
        end

        object
      end

      def serialize_collection
        if success?
          object.authorizations = serialize_authorizations
        else
          object.errors.add(response)
        end

        object
      end

      def success?
        response.success? && response.xml?
      end

      private
      # The request response.
      attr_reader :response

      # The PagSeguro::Authorization or PagSeguro::Authorization::Collection object
      attr_reader :object

      def serialize_authorizations
        Nokogiri::XML(response.body).css('authorizations > authorization').map do |node|
          Authorization.new(ResponseSerializer.new(node).serialize)
        end
      end
    end
  end
end
