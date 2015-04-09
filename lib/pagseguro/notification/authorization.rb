module PagSeguro
  class Notification
    class Authorization < PagSeguro::Notification
      # Detect if the notification is from an authorization.
      def authorization?
        type == "applicationAuthorization"
      end

      # Fetch the authorization by its notificationCode.
      def authorization
        Authorization.find_by_notification_code(code)
      end
    end
  end
end
