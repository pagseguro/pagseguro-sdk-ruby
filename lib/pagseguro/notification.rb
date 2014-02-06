module PagSeguro
  class Notification
    include PagSeguro::Extensions::MassAssignment

    # The notification code sent by PagSeguro.
    attr_accessor :code

    # The notification type sent by PagSeguro.
    attr_accessor :type

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
