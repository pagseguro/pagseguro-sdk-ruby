module PagSeguro
  class Authorization
    class Report
      attr_reader :errors

      def initialize(xml, errors)
        @xml = xml
        @errors = errors
      end

      # A array containing all permissions for the current authorization.
      # Each permission is a hash, with code, status and last update date
      def permissions
        @permissions ||= @xml.css("permission").map do |node|
          PagSeguro::Permission.new({
            code: node.css("code").text,
            status: node.css("status").text,
            last_update: node.css("lastUpdate").text
          })
        end
      end

      # The report's creation date.
      def created_at
        @created_at ||= Time.parse @xml.css("creationDate").text
      end

      # The authorization code
      def code
        @code ||= @xml.css("> code").text
      end

      # the authorization reference
      def reference
        @reference ||= @xml.css("reference").text
      end

    end
  end
end
