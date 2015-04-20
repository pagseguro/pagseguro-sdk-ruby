module PagSeguro
  class Authorization
    class Report
      attr_reader :xml

      def initialize(xml)
        @xml = xml
      end

      # A array containing all permissions for the current authorization.
      # Each permission is a hash, with code, status and last update date
      def permissions
        @transactions ||= xml.css("authorization permission").map do |node|
          {
            code: node.css("code").text,
            status: node.css("status").text,
            last_update: node.css("lastUpdate").text
          }
        end
      end

      # The report's creation date.
      def created_at
        @created_at ||= Time.parse xml.css("authorization > creationDate").text
      end

      # The authorization code
      def code
        @code ||= xml.css("authorization > code").text
      end

      # the authorization reference
      def reference
        @reference ||= xml.css("authorization > reference").text
      end

    end
  end
end
