module PagSeguro
  class Installment
    class ResponseSerializer
      # The installment that will be serialized
      attr_reader :xml

      def initialize(xml)
        @xml = xml
      end

      def serialize
        {}.tap do |data|
          data[:card_brand] = xml.css("cardBrand").text
          data[:quantity] = xml.css("quantity").text
          data[:amount] = xml.css("amount").text
          data[:total_amount] = xml.css("totalAmount").text
          data[:interest_free] = xml.css("interestFree").text
        end
      end
    end
  end
end
