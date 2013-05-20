module PagSeguro
  class Transaction
    include Extensions::MassAssignment
    include Extensions::EnsureType

    # When the payment request was created.
    attr_accessor :created_at

    # The transaction code.
    attr_accessor :code

    # The reference code identifies the order you placed on the payment request.
    # It's used by the store and can be something like the order id.
    attr_accessor :reference

    # The transaction type.
    attr_accessor :type_id

    # The last notification's update.
    attr_accessor :updated_at

    # The transaction status.
    attr_reader :status

    # The payment method.
    attr_reader :payment_method

    attr_accessor :payment_link
    attr_accessor :gross_amount
    attr_accessor :discount_amount
    attr_accessor :fee_amount
    attr_accessor :net_amount

    # Set the extra amount applied to the transaction's total.
    # It's considered as an extra charge when positive, or a discount if
    # negative.
    attr_accessor :extra_amount

    # The installment count.
    attr_accessor :installments

    # The payer information (who is sending money).
    attr_reader :sender

    # The shipping information.
    attr_reader :shipping

    # Find a transaction by its code.
    # Return a PagSeguro::Transaction instance.
    def self.find_by_code(code)
      load_from_response Request.get("transactions/notifications/#{code}")
    end

    # Serialize the HTTP response into data.
    def self.load_from_response(response) # :nodoc:
      new Serializer.new(response).serialize
    end

    # Normalize the sender object.
    def sender=(sender)
      @sender = ensure_type(Sender, sender)
    end

    # Normalize the shipping object.
    def shipping=(shipping)
      @shipping = ensure_type(Shipping, shipping)
    end

    # Hold the transaction's items.
    def items
      @items ||= Items.new
    end

    # Normalize the items list.
    def items=(_items)
      _items.each {|item| items << item }
    end

    # Normalize the payment method.
    def payment_method=(payment_method)
      @payment_method = ensure_type(PaymentMethod, payment_method)
    end

    # Normalize the payment status.
    def status=(status)
      @status = ensure_type(PaymentStatus, status)
    end
  end
end
