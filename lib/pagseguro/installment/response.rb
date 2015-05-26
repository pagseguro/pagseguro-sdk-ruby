module PagSeguro
  class Installment
    class Response
      def initialize(response)
        @response = response
      end

      def serialize
        if response.success? && response.xml?
          Nokogiri::XML(response.body).css("installments > installment").map do |node|
            ResponseSerializer.new(xml).serialize
          end
        else
          { errors: Errors.new(response) }
        end
      end

      private
      # The request response.
      attr_reader :response
    end
  end
end
