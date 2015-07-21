module PagSeguro
  class PaymentReleases
    include Enumerable
    extend Forwardable
    include Extensions::EnsureType

    def_delegators :@payments, :each, :size

    def initialize
      @payments = []
    end

    # Adds payment to payment list.
    def <<(payment)
      payment = ensure_type(PaymentRelease, payment)

      @payments << payment unless @payments.include? payment
    end

    # Verify if a payment is already included to payment list.
    # Returns Boolean.
    def include?(payment)
      self.find do |included_payment|
        included_payment.installment == ensure_type(PaymentRelease, payment).installment
      end
    end
  end
end
