module PagSeguro
  class Authorization
    class Serializer
      attr_reader :authorization, :notification_url, :redirect_url

      def initialize(authorization, notification_url, redirect_url)
        @authorization = authorization
        @notification_url = notification_url
        @redirect_url = redirect_url
      end

      def to_params
        params[:appId] = authorization.app_id
        params[:appKey] = authorization.app_key
        params[:notificationURL] = notification_url
        params[:redirectURL] = redirect_url
        params[:permissions] = serialize_permissions(authorization.permissions)
        params[:reference] = authorization.reference if authorization.reference

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
