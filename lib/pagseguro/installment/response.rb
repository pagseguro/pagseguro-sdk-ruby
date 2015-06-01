module PagSeguro
  class Installment
    class Response
      def initialize(response)
        @response = response
      end

      def serialize
        if response.success? && response.xml?
          { installments: serialize_installments }
        else
          { errors: Errors.new(response) }
        end
      end

      private
      # The request response.
      attr_reader :response

      def serialize_installments
        Nokogiri::XML(response.body).css("installments > installment").map do |node|
          ResponseSerializer.new(node).serialize
        end
      end
    end
  end
end
