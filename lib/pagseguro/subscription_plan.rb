module PagSeguro
  class SubscriptionPlan
    API_VERSION = 'v2'

    include Extensions::MassAssignment
    include Extensions::Credentiable
    include Extensions::EnsureType

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

    # The total limit of the payment (per period)
    attr_accessor :max_amount_per_period

    # The date time to finish the payment
    attr_accessor :final_date

    # The membership fee, it charge with the amount at the first time
    attr_accessor :membership_fee

    # The trial period, in days, of the user to the subscription
    attr_accessor :trial_duration

    # The code of a created to the plan, must be saved
    attr_accessor :code

    # The reference of the plan
    attr_accessor :reference

    # The url to redirect the user
    attr_accessor :redirect_url

    # The url to review the user
    attr_accessor :review_url

    # The details of the plan
    attr_accessor :details

    # Get the payment sender.
    attr_reader :sender

    # Get the address of sender.
    attr_reader :sender_address

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

    # Set sender's address
    def sender_address=(address)
      @sender_address = ensure_type(Address, address)
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
