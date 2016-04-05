module PagSeguro
  class SubscriptionPaymentOrder
    class Response
      def initialize(response, object)
        @response = response
        @object = object
      end

      def serialize
        if success?
          object.update_attributes serialized_data
        else
          object.errors.add response
        end

        object
      end

      def success?
        response.success? && response.xml?
      end

      private

      attr_reader :response
      attr_reader :object

      def serialized_data
        ResponseSerializer.new(xml).serialize
      end

      def xml
        Nokogiri::XML(response.data)
      end
    end
  end
end
