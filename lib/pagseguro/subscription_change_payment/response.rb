module PagSeguro
  class SubscriptionChangePayment
    class Response

      attr_reader :response
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
    end
  end
end
