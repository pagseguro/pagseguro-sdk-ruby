module PagSeguro
  class SubscriptionPlan
    API_VERSION = 'v2'

    include Extensions::MassAssignment
    include Extensions::Credentiable
    include Extensions::EnsureType

    attr_accessor :max_users
    attr_accessor :name
    attr_accessor :charge
    attr_accessor :period
    attr_accessor :amount
    attr_accessor :max_total_amount
    attr_accessor :max_amount_per_period
    attr_accessor :max_payments_per_period
    attr_accessor :max_amount_per_payment
    attr_accessor :final_date
    attr_accessor :initial_date
    attr_accessor :membership_fee
    attr_accessor :trial_duration
    attr_accessor :code
    attr_accessor :reference
    attr_accessor :redirect_url
    attr_accessor :review_url
    attr_accessor :details

    attr_reader :sender

    # Set errors
    def errors
      @errors ||= Errors.new
    end

    # Update all attributes
    def update_attributes(attrs)
      attrs.each { |name, value| send("#{name}=", value) }
    end

    # Set sender
    def sender=(sender)
      @sender = ensure_type(Sender, sender)
    end

    def create
      request = Request.post_xml('pre-approvals/request', API_VERSION, credentials, xml_params)

      Response.new(request, self).serialize

      self
    end

    def url
      return unless code

      "#{PagSeguro.uris[PagSeguro.environment][:site]}v2/pre-approvals/request.html?code=#{code}"
    end

    private

    def xml_params
      RequestSerializer.new(self).to_xml_params
    end

    def after_initialize
      @errors = Errors.new
    end
  end
end
