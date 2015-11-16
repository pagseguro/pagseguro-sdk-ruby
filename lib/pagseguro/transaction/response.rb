module PagSeguro
  class Transaction
    class Response
      def initialize(response, object)
        @response = response
        @object = object
      end

      def serialize
        if success?
          object.update_attributes(Serializer.new(xml).serialize)
        else
          object.errors.add response
        end

        object
      end

      def serialize_statuses
        if success?
          object.statuses = Serializer.new(xml).serialize_status_history
        else
          object.errors.add(response)
        end

        object
      end

      def success?
        response.success? && response.xml?
      end

      # The http response.
      attr_reader :response

      # Set the that will receive errors or updates
      attr_reader :object

      private
      def xml
        Nokogiri::XML(response.body)
      end
    end
  end
end
