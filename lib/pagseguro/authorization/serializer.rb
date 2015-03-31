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

      attr_reader :notification_url

      attr_reader :redirect_url

      attr_reader :permissions

      def initialize(notification_url, redirect_url, permissions = PERMISSIONS.keys)
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
        permissions.map { |value| PERMISSIONS[value] }.join(',')
      end
    end
  end
end
