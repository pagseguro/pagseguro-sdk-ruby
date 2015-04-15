module PagSeguro
  class Authorization
    class Serializer
      attr_reader :authorization

      def initialize(authorization)
        @authorization = authorization
      end

      def to_params
        params[:credentials] = authorization.credentials if authorization.credentials
        params[:notificationURL] = authorization.notification_url
        params[:redirectURL] = authorization.redirect_url
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
