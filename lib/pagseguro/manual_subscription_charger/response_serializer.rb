module PagSeguro
  class ManualSubscriptionCharger
    class ResponseSerializer
      attr_reader :xml

      def initialize(xml)
        @xml = xml
      end

      def serialize
        {}.tap do |data|
          data[:transaction_code] = xml.css('result > transactionCode').text
        end
      end
    end
  end
end
