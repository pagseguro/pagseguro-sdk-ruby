module PagSeguro
  class ManualSubscriptionCharger
    class Response
      # The http response.
      attr_reader :response

      # Set the boject that will receive errors or updates
      attr_reader :object

      def initialize(response, object)
        @response = response
        @object = object
      end

      def serialize
        if success?
          object.update_attributes(ResponseSerializer.new(xml).serialize)
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
    end
  end
end
