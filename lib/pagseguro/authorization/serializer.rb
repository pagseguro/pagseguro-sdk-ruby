module PagSeguro
  class Authorization
    class Serializer
      attr_reader :notification_url

      attr_reader :redirect_url

      attr_reader :permissions

      def initialize(notification_url, redirect_url, permissions)
        @notification_url = notification_url
        @redirect_url = redirect_url
        @permissions = permissions
      end

      def to_params
        params[:notificationURL] = notification_url
        params[:redirectURL] = redirect_url
        params[:permissions] = serialize_permissions(permissions)

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
