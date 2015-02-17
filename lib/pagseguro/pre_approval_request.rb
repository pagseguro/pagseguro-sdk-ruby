module PagSeguro
  class PreApprovalRequest
    include Extensions::MassAssignment
    include Extensions::EnsureType

    # Get the payment sender.
    attr_reader :sender

    attr_accessor :charge
    attr_accessor :name
    attr_accessor :details
    attr_accessor :amount_per_payment
    attr_accessor :period
    attr_accessor :final_date

    attr_accessor :redirect_url
    attr_accessor :reference
    attr_accessor :review_url

    attr_accessor :email
    attr_accessor :token

    attr_accessor :max_amount_per_payment
    attr_accessor :max_payments_per_period
    attr_accessor :max_amount_per_period
    attr_accessor :max_total_amount

    # Set the payment sender.
    def sender=(sender)
      @sender = ensure_type(Sender, sender)
    end

    # Calls the PagSeguro web service and register this request for pre_approval.
    def register
      params = Serializer.new(self).to_params.merge({
        email: email,
        token: token
      })
      Response.new Request.post("pre_approval", params)
    end

    private
    def before_initialize
      self.charge = "manual"
      self.email    = PagSeguro.email
      self.token    = PagSeguro.token
    end
 
  end
end