module PagSeguro
  class SubscriptionChangePayment
    include Extensions::Credentiable
    include Extensions::EnsureType
    include Extensions::MassAssignment

    attr_accessor :subscription_code

    attr_reader :sender
    attr_reader :subscription_payment_method

    def sender=(sender)
      @sender = ensure_type(Sender, sender)
    end

    def holder=(holder)
      @holder = ensure_type(Holder, holder)
    end

    def subscription_payment_method=(payment_method)
      @subscription_payment_method = ensure_type(SubscriptionPaymentMethod, payment_method)
    end

    def errors
      @errors ||= Errors.new
    end

    def update
      request = Request.put_xml("pre-approvals/#{subscription_code}/payment-method", credentials, params)

      Response.new(request, self).serialize

      self
    end

    private

    def params
      RequestSerializer.new(self).serialize
    end

    def after_initialize
      @errors = Errors.new
    end
  end
end
