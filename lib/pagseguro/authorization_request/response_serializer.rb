module PagSeguro
  class AuthorizationRequest
    class ResponseSerializer
      attr_reader :xml

      def initialize(xml)
        @xml = xml
      end

      def serialize
        {}.tap do |data|
          data[:code] = xml.css("> code").text
          data[:date] = Time.parse xml.css("date").text
        end
      end
    end
  end
end
