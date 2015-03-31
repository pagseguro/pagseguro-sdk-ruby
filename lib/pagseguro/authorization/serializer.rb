module PagSeguro
  class Authorization
    class Serializer
      PERMISSIONS = {
        checkouts: 'CREATE_CHECKOUTS',
        notifications: 'RECEIVE_TRANSACTION_NOTIFICATIONS',
        searches: 'SEARCH_TRANSACTIONS',
        pre_approvals: 'MANAGE_PAYMENT_PRE_APPROVALS',
        payments: 'DIRECT_PAYMENTS'
      }

      attr_reader :authorization

      attr_reader :permissions

      def initialize(authorization, permissions = PERMISSIONS.keys)
        @authorization = authorization
        @permissions = permissions
      end

      def to_params
        params[:appId] = authorization.app_id
        params[:appKey] = authorization.app_key
        params[:notificationUrl] = authorization.notification_url
        params[:redirectUrl] = authorization.redirect_url
        params[:permissions] = serialize_permissions(permissions)

        params
      end

      private
      def params
        @params ||= {}
      end

      def serialize_permissions(permissions)
        permissions.map { |value| PERMISSIONS[value] }.join(',')
      end
    end
  end
end
