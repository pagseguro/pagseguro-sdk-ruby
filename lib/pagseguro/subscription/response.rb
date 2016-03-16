module PagSeguro
  class Subscription
    class Response
      # The http response
      attr_reader :response

      # Set the object that will recive errors or updates
      attr_reader :object

      def initialize(response, object)
        @response = response
        @object = object
      end

      def serialize
        if success?
          object.update_attributes(serialized_data)
        else
          object.errors.add response
        end

        object
      end

      def success?
        response.success? && response.xml?
      end

      private

      def xml
        Nokogiri::XML(response.body)
      end

      def serialized_data
        ResponseSerializer.new(xml).serialize
      end
    end
  end
end
