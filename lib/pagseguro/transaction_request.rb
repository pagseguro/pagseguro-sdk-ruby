module PagSeguro
  class TransactionRequest
    include Extensions::MassAssignment
    include Extensions::EnsureType

    # Set the payment currency.
    # Defaults to BRL.
    attr_accessor :currency

    # Get the payment sender.
    attr_reader :sender

    # Get the shipping info.
    attr_reader :shipping

    # Set the extra amount to be applied to the transaction's total.
    # This value can be used to add an extra charge to the transaction
    # or provide a discount, if negative.
    attr_accessor :extra_amount

    # Set the reference code.
    # Optional. You can use the reference code to store an identifier so you can
    # associate the PagSeguro transaction to a transaction in your system.
    # Tipically this is the order id.
    attr_accessor :reference

    # Determines for which url PagSeguro will send the order related
    # notifications codes.
    # Optional. Any change happens in the transaction status, a new notification
    # request will be send to this url. You can use that for update the related
    # order.
    attr_accessor :notification_url

    # Set the payment mode.
    attr_accessor :payment_mode

    # The extra parameters for payment request.
    attr_accessor :extra_params

    # The transaction code returned from api.
    attr_reader :code

    # The transaction type returned from api.
    attr_reader :type_id

    # The payment link returned from api.
    attr_reader :payment_link

    # The transaction status returned from api.
    attr_reader :status

    # The payment method returned from api.
    attr_reader :payment_method

    # The gross amount returned from api.
    attr_reader :gross_amount

    # The discount amount returned from api.
    attr_reader :discount_amount

    # The net amount returned from api.
    attr_reader :net_amount

    # The installments number returned from api.
    attr_reader :installment_count

    # The created at date returned from api
    attr_reader :created_at

    # The updated at date returned from api
    attr_reader :updated_at

    attr_writer :errors

    # Products/items in this payment request.
    def items
      @items ||= Items.new
    end

    def errors
      @errors ||= Errors.new
    end

    # Subclasses must implement payment_method
    def payment_method
      raise NotImplementedError.new("'#payment_method' must be implemented in specific class")
    end

    # Set the payment sender.
    def sender=(sender)
      @sender = ensure_type(Sender, sender)
    end

    # Set the shipping info.
    def shipping=(shipping)
      @shipping = ensure_type(Shipping, shipping)
    end

    # Calls the PagSeguro web service and create this request for payment.
    # Return boolean.
    def create
      request = Request.post("transactions", api_version, params)
      Response.new(request, self).serialize
    end

    def update_attributes(attrs)
      attrs.map { |name, value| send("#{name}=", value) }
    end

    private
    attr_writer :code, :type_id, :payment_link, :status, :payment_method,
      :gross_amount, :discount_amount, :net_amount, :installment_count,
      :created_at, :updated_at

    def before_initialize
      self.currency = "BRL"
      self.extra_params = []
    end

    def params
      RequestSerializer.new(self).to_params
    end

    # Used to set response items from api.
    def items=(items)
      @items = Items.new
      items.map { |item| @items << item }
    end

    # Used to set the payment method from api.
    def payment_method=(payment_method)
      @payment_method = ensure_type(PaymentMethod, payment_method)
    end

    private
    def api_version
      'v2'
    end
  end
end
