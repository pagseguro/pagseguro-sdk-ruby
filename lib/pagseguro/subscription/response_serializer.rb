module PagSeguro
  class Subscription
    class ResponseSerializer
      attr_reader :xml

      def initialize(xml)
        @xml = xml
      end

      def serialize
        {}.tap do |data|
          data[:code] = xml.at_css('directPreApproval > code').text
        end
      end
    end
  end
end
