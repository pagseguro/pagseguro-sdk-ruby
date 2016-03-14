module PagSeguro
  class SubscriptionPlan
    class ResponseSerializer
      attr_reader :xml

      def initialize(xml)
        @xml = xml
      end

      def serialize
        {}.tap do |data|
          data[:code] = xml.css('preApprovalRequest > code').text
        end
      end
    end
  end
end
