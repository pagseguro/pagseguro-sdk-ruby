module PagSeguro
  class Notification
    class Transaction < PagSeguro::Notification
      # Detect if the notification is from a transaction.
      def transaction?
        type == "transaction"
      end

      # Fetch the transaction by its notificationCode.
      def transaction
        Transaction.find_by_notification_code(code)
      end
    end
  end
end
