module PagSeguro
  class TransactionCancellation
    class Response
      def initialize(response, cancellation)
        @response = response
        @cancellation = cancellation
      end

      def serialize
        if success?
          xml = Nokogiri::XML(response.body)
          cancellation.update_attributes(ResponseSerializer.new(xml).serialize)
        else
          cancellation.errors.add(response)
        end

        cancellation
      end

      def success?
        response.success? && response.xml?
      end

      private
      # The request response.
      attr_reader :response

      # The PagSeguro::TransactionCancellation instance.
      attr_reader :cancellation
    end
  end
end
