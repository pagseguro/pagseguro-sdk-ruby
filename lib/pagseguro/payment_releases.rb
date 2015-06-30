module PagSeguro
  class PaymentReleases
    include Enumerable
    extend Forwardable
    include Extensions::EnsureType

    def_delegators :@payments, :each, :size

    def initialize
      @payments = []
    end

    # Adds a new item to payment list.
    def <<(payment)
      payment = ensure_type(PaymentRelease, payment)

      @payments << payment unless @payments.include? payment
    end

    # Verify if the item is already included to payment list.
    # Return Boolean.
    def include?(payment)
      self.find do |included_payment|
        included_payment.installment == ensure_type(PaymentRelease, payment).installment
      end
    end
  end
end
