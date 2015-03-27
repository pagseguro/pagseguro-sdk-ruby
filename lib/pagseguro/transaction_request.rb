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

    # Get the bank info.
    attr_reader :bank

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

    # Set the payment method.
    attr_accessor :payment_method

    # Set the payment mode.
    attr_accessor :payment_mode

    # Set credit card token.
    # Required if payment method is credit card.
    attr_accessor :credit_card_token

    # Get credit card holder info.
    attr_reader :holder

    # Get billing address info.
    attr_reader :billing_address

    # Get installment info.
    attr_reader :installment

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

    # Set the shipping info.
    def shipping=(shipping)
      @shipping = ensure_type(Shipping, shipping)
    end

    # Set the bank.
    # Required if payment method is online debit.
    def bank=(bank)
      @bank = ensure_type(Bank, bank)
    end

    # Set the credit card holder.
    # Required if payment method is credit card
    def holder=(holder)
      @holder = ensure_type(Holder, holder)
    end

    # Set the billing address.
    def billing_address=(address)
      @billing_address = ensure_type(Address, address)
    end

    # Set the installment
    def installment=(installment)
      @installment = ensure_type(TransactionInstallment, installment)
    end

    # Calls the PagSeguro web service and register this request for payment.
    def register
      Response.new(Request.post("transactions", api_version, params))
    end

    private
    def before_initialize
      self.currency = "BRL"
      self.extra_params = []
    end

    def params
      Serializer.new(self).to_params
    end

    # The default PagSeguro API version
    def api_version
      'v2'
    end
  end
end
