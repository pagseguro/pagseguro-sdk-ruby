module PagSeguro
  class PaymentReleases
    include Enumerable
    include Extensions::EnsureType

    def initialize
      @payments = []
    end

    def <<(payment)
      payment = ensure_type(PaymentRelease, payment)

      @payments << payment unless @payments.include? payment
    end

    def include?(payment)
      self.find do |included_payment|
        included_payment.installment == ensure_type(PaymentRelease, payment).installment
      end
    end
  end
end
