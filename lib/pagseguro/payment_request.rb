module PagSeguro
  class PaymentRequest
    include Extensions::MassAssignment
    include Extensions::EnsureType
    include Extensions::Credentiable

    # Set the payment currency.
    # Defaults to BRL.
    attr_accessor :currency

    # Get the payment sender.
    attr_reader :sender

    # Set and get primary receiver email.
    attr_accessor :primary_receiver

    # Get the payment receivers.
    attr_reader :receivers

    # Get the shipping info.
    attr_reader :shipping

    # Set the redirect url.
    # The URL that will be used by PagSeguro to redirect the user after
    # the payment information is processed. Typically this is a
    # confirmation page on your web site.
    attr_accessor :redirect_url

    # Set the extra amount to be applied to the transaction's total.
    # This value can be used to add an extra charge to the transaction
    # or provide a discount, if negative.
    attr_accessor :extra_amount

    # Set the reference code.
    # Optional. You can use the reference code to store an identifier so you can
    # associate the PagSeguro transaction to a transaction in your system.
    # Tipically this is the order id.
    attr_accessor :reference

    # Set the payment request duration, in seconds.
    attr_accessor :max_age

    # How many times the payment redirect uri returned by the payment
    # web service can be accessed.
    # Optional. After this payment request is submitted, the payment
    # redirect uri returned by the payment web service will remain valid
    # for the number of uses specified here.
    attr_accessor :max_uses

    # Determines for which url PagSeguro will send the order related
    # notifications codes.
    # Optional. Any change happens in the transaction status, a new notification
    # request will be send to this url. You can use that for update the related
    # order.
    attr_accessor :notification_url

    # Determines for which url PagSeguro will send the buyer when he doesn't
    # complete the payment.
    attr_accessor :abandon_url

    # The extra parameters for payment request
    attr_accessor :extra_params

    # Products/items in this payment request.
    def items
      @items ||= Items.new
    end

    # Set the payment sender.
    def sender=(sender)
      @sender = ensure_type(Sender, sender)
    end

    # Set the receivers.
    def receivers=(receivers)
      receivers.each do |receiver|
        @receivers << ensure_type(Receiver, receiver)
      end
    end

    # Set the shipping info.
    def shipping=(shipping)
      @shipping = ensure_type(Shipping, shipping)
    end

    # Calls the PagSeguro web service and register this request for payment.
    def register
      request = if @receivers.empty?
                  Request.post('checkout', api_version, params)
                else
                  Request.post_xml('checkouts', api_version, credentials, xml_params)
                end

      Response.new(request)
    end

    private

    def xml_params
      RequestSerializer.new(self).to_xml_params
    end

    def params
      RequestSerializer.new(self).to_params
    end

    def before_initialize
      self.extra_params = []
      self.currency = "BRL"
      @receivers = []
    end

    def api_version
      'v2'
    end
  end
end
