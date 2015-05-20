module PagSeguro
  class Authorization
    class RequestSerializer
      attr_reader :xml

      def initialize(xml)
        @xml = xml
      end

      def serialize
        params[:credentials] = xml.credentials if xml.credentials
        params[:notificationURL] = xml.notification_url
        params[:redirectURL] = xml.redirect_url
        params[:permissions] = serialize_permissions(xml.permissions)
        params[:reference] = xml.reference if xml.reference

        params
      end

      private
      def params
        @params ||= {}
      end

      def serialize_permissions(permissions)
        permissions.map { |value| PagSeguro::Authorization::PERMISSIONS[value] }.join(',')
      end
    end
  end
end
