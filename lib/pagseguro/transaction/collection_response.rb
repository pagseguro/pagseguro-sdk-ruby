module PagSeguro
  class Transaction
    class CollectionResponse
      def initialize(response, collection)
        @response = response
        @collection = collection
      end

      def serialize
        if success?
          xml = Nokogiri::XML(response.body)
          collection.transactions = Serializer.new(xml).serialize_status_history
        else
          collection.errors.add(response)
        end

        collection
      end

      def success?
        response.success? && response.xml?
      end

      private
      # Response object.
      attr_reader :response

      # Collection.
      attr_reader :collection
    end
  end
end
