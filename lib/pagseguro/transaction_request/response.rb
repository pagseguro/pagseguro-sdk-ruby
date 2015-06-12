module PagSeguro
  class TransactionRequest
    class Response
      def initialize(response, transaction_request)
        @response = response
        @transaction_request = transaction_request
      end

      def serialize
        if success?
          xml = Nokogiri::XML(response.body).css("transaction").first
          transaction_request.update_attributes(ResponseSerializer.new(xml).serialize)
        else
          transaction_request.errors.add(response)
        end

        transaction_request
      end

      def success?
        response.success? && response.xml?
      end

      private
      # The request response.
      attr_reader :response

      # The TransactionRequest instance.
      attr_reader :transaction_request
    end
  end
end
