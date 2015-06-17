module PagSeguro
  class TransactionCancellation
    class ResponseSerializer
      attr_reader :xml

      def initialize(xml)
        @xml = xml
      end

      def serialize
        {}.tap do |data|
          data[:result] = xml.css("> result").text
        end
      end
    end
  end
end
