module PagSeguro
  class TransactionCancellation
    class Response
      def initialize(response, object)
        @response = response
        @object = object
      end

      def serialize
        if success?
          xml = Nokogiri::XML(response.body)
          serializer = ResponseSerializer.new(xml).serialize
          object.update_attributes(serializer)
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

      # The PagSeguro::TransactionCancellation instance.
      attr_reader :object
    end
  end
end
