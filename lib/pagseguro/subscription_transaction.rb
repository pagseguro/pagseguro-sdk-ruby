module PagSeguro
  class SubscriptionTransaction
    include Extensions::MassAssignment

    STATUSES = {
      waiting_payment: 1,
      in_review: 2,
      paid: 3,
      available: 4,
      in_dispute: 5,
      returned: 6,
      canceled: 7,
      charged: 8,
      temporary_retention: 9
    }

    attr_accessor :code
    attr_accessor :status
    attr_accessor :date

    def status_code
      STATUSES[status.to_sym]
    end

    def ==(object)
      [code, status, date] == [object.code, object.status, object.date]
    end
  end
end
