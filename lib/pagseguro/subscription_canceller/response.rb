module PagSeguro
  class SubscriptionCanceller
    class Response
      # The http response.
      attr_reader :response

      # Set the object that will receive errors or updates
      attr_reader :object

      def initialize(response, object)
        @response = response
        @object = object
      end

      def serialize
        unless success?
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
