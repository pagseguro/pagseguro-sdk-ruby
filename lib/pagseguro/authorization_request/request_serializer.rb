module PagSeguro
  class AuthorizationRequest
    class RequestSerializer
      attr_reader :authorization_request

      def initialize(authorization_request)
        @authorization_request = authorization_request
      end

      def to_params
        params[:credentials] = authorization_request.credentials if authorization_request.credentials
        params[:notificationURL] = authorization_request.notification_url
        params[:redirectURL] = authorization_request.redirect_url
        params[:permissions] = serialize_permissions(authorization_request.permissions)
        params[:reference] = authorization_request.reference if authorization_request.reference

        params
      end

      private
      def params
        @params ||= {}
      end

      def serialize_permissions(permissions)
        permissions.map { |value| PagSeguro::AuthorizationRequest::PERMISSIONS[value] }.join(',')
      end
    end
  end
end
