module PagSeguro
  class Session
    class ResponseSerializer
      # The session that will be serialized
      attr_reader :xml

      def initialize(xml)
        @xml = xml
      end

      def serialize
        {}.tap do |data|
          data[:id] = xml.css("id").text
        end
      end
    end
  end
end
