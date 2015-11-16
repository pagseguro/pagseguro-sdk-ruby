module PagSeguro
  class TransactionStatus
    include Extensions::MassAssignment

    # The transaction status code
    attr_accessor :code

    # The date of the status change
    attr_accessor :date

    # The code of the notification sent when the status changed
    attr_accessor :notification_code
  end
end
