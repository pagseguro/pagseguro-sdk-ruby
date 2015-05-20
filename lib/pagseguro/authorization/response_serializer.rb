module PagSeguro
  class Authorization
    class ResponseSerializer
      attr_reader :response

      def initialize(response)
        @response = response
      end


      def serialize_authorization
        {
          permissions: authorization_request_permissions,
          created_at: created_at,
          code: code,
          reference: reference
        }.delete_if { |key, value| value.nil? }
      end

      def serialize_attributes
        permissions: permissions,
      end


      private

      def authorization_request_permissions
        @xml.css("permissions").map { |node| node.css("code").text }
      end

      # A array containing all permissions for the current authorization.
      # Each permission is a hash, with code, status and last update date
      def permissions
        @xml.css("permission").map do |node|
          PagSeguro::Permission.new({
            code: node.css("code").text,
            status: node.css("status").text,
            last_update: node.css("lastUpdate").text
          })
        end
      end

      # The report's creation date.
      def created_at
        Time.parse @xml.css("creationDate").text
      end

      # The authorization code
      def code
        @xml.css("> code").text
      end

      # the authorization reference
      def reference
        @xml.css("reference").text
      end
    end
  end
end
