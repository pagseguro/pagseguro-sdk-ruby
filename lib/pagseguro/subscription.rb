module PagSeguro
  # It lets you create a subscription without going through PagSeguro screens.
  class Subscription
    include Extensions::MassAssignment
    include Extensions::EnsureType
    include Extensions::Credentiable

    # Set the plan
    attr_accessor :plan

    # Set the reference
    attr_accessor :reference

    # Get the sender
    attr_reader :sender

    # Get the payment method
    attr_reader :payment_method

    # The code of a created to the subscription, must be saved
    attr_accessor :code

    # Set the sender
    def sender=(sender)
      @sender = ensure_type(Sender, sender)
    end

    # Set the payment method
    def payment_method=(payment_method)
      @payment_method = ensure_type(SubscriptionPaymentMethod, payment_method)
    end

    def update_attributes(attrs)
      attrs.each {|name, value| send("#{name}=", value)  }
    end

    def create
      request = Request.post_xml('pre-approvals', nil, credentials, xml_params, extra_options)
      Response.new(request, self).serialize
      self
    end

    def errors
      @errors ||= Errors.new
    end

    private

    def xml_params
      RequestSerializer.new(self).serialize
    end

    def extra_options
      {}.tap do |h|
        h[:headers] = { "Accept" => "application/vnd.pagseguro.com.br.v1+xml;charset=ISO-8859-1" }
      end
    end

    def after_initialize
      @errors = Errors.new
    end
  end
end
