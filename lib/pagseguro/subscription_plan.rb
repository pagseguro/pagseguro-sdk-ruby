module PagSeguro
  class SubscriptionPlan
    API_VERSION = 'v2'

    include Extensions::MassAssignment
    include Extensions::Credentiable

    # Max users a plan can have at time
    attr_accessor :max_users

    # The name of the plan
    attr_accessor :name

    # The charge of payment
    attr_accessor :charge

    # The period of payment
    attr_accessor :period

    # The amount of each payment
    attr_accessor :amount

    # The total limit of the payment
    attr_accessor :max_amount

    # The date time to finish the payment
    attr_accessor :final_date

    # The membership fee, it charge with the amount at the first time
    attr_accessor :membership_fee

    # The trial period, in days, of the user to the subscription
    attr_accessor :trial_duration

    # The code of a created to the plan, must be saved
    attr_accessor :code

    # Set errors
    def errors
      @errors ||= Errors.new
    end

    # Update all attributes
    def update_attributes(attrs)
      attrs.each { |name, value| send("#{name}=", value) }
    end

    def create
      request = Request.post_xml('pre-approvals/request', API_VERSION, credentials, xml_params)

      Response.new(request, self).serialize

      self
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
