module PagSeguro
  class Installment
    class Response
      def initialize(response, collection)
        @response = response
        @collection = collection
      end

      def serialize
        if success?
          collection.installments = serialize_installments
        else
          collection.errors.add(response)
        end

        collection
      end

      def success?
        response.success? && response.xml?
      end

      private
      # The request response.
      attr_reader :response

      # The PagSeguro::Installment::Collection instance.
      attr_reader :collection

      def serialize_installments
        Nokogiri::XML(response.body).css("installments > installment").map do |node|
          ResponseSerializer.new(node).serialize
        end
      end
    end
  end
end
