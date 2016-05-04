module PagSeguro
  class SubscriptionPaymentOrder
    include Extensions::MassAssignment
    include Extensions::EnsureType

    STATUSES = {
      scheduled: 1,
      processing: 2,
      not_processed: 3,
      suspended: 4,
      paid: 5,
      not_paid: 6
    }

    attr_accessor :errors

    attr_accessor :code
    attr_accessor :status
    attr_accessor :amount
    attr_accessor :gross_amount
    attr_accessor :last_event_date
    attr_accessor :scheduling_date
    attr_reader :discount

    def discount=(discount)
      @discount = ensure_type(PagSeguro::SubscriptionDiscount, discount)
    end

    def transactions
      @transactions ||= SubscriptionTransactions.new
    end

    def transactions=(attrs)
      attrs.each do |params|
        transactions << SubscriptionTransaction.new(params)
      end
    end

    def status_code
      STATUSES[@status.to_sym]
    end

    def update_attributes(attrs)
      attrs.each {|name, value| send("#{name}=", value)  }
    end

    def self.load_from_xml(xml)
      new ResponseSerializer.new(xml).serialize
    end

    private

    def after_initialize
      @errors ||= Errors.new
    end
  end
end
