module PagSeguro
  class Authorization
    class ResponseSerializer

      def initialize(xml)
        @xml = xml
      end

      def serialize
        {}.tap do |data|
          serialize_general(data)
          serialize_permissions(data)
        end
      end

      private
      def serialize_general(data)
        data[:code] = xml.css("> code").text
        data[:reference] = xml.css("reference").text
        data[:created_at] = Time.parse xml.css("creationDate").text
      end

      def serialize_permissions(data)
        data[:permissions] = []

        xml.css("permission").each do |node|
          permission = PagSeguro::Permission.new
          permission.code = node.css("code").text
          permission.status = node.css("status").text
          permission.last_update = node.css("lastUpdate").text

          data[:permissions] << permission
        end
      end

      attr_reader :xml
    end
  end
end
