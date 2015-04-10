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

    # The boleto payment url.
    attr_accessor :payment_link

    # The gross amount.
    attr_accessor :gross_amount

    # The discount amount.
    attr_accessor :discount_amount

    # The PagSeguro fee amount.
    attr_accessor :fee_amount

    # The net amount.
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

    # The cancellation source.
    attr_accessor :cancellation_source

    # The escrow end date.
    attr_accessor :escrow_end_date

    # Set the transaction errors.
    attr_reader :errors

    # Find a transaction by its transactionCode
    # Return a PagSeguro::Transaction instance
    def self.find_by_code(code)
      load_from_response Request.get("transactions/#{code}")
    end

    # Find a transaction by its notificationCode.
    # Return a PagSeguro::Transaction instance.
    def self.find_by_notification_code(code)
      load_from_response Request.get("transactions/notifications/#{code}")
    end

    # Search transactions within a date range.
    # Return a PagSeguro::Report instance.
    #
    # Options:
    #
    # # +starts_at+: the starting date. Defaults to the last 24-hours.
    # # +ends_at+: the ending date.
    # # +page+: the current page.
    # # +per_page+: the result limit.
    #
    def self.find_by_date(options = {}, page = 0)
      options = {
        starts_at: Time.now - 86400,
        ends_at: Time.now,
        per_page: 50
      }.merge(options)

      Report.new(Transaction, "transactions", options, page)
    end

    # Get abandoned transactions.
    # Return a PagSeguro::Report instance.
    #
    # Options:
    #
    # # +starts_at+: the starting date. Defaults to the last 24-hours.
    # # +ends_at+: the ending date. Defaults to 15 minutes ago. **Attention:** you have to set it this to <tt>Time.now - 15 minutes</tt>, otherwise the "finalDate must be lower than allowed limit" error will be returned.
    # # +page+: the current page.
    # # +per_page+: the result limit.
    #
    def self.find_abandoned(options = {}, page = 0)
      options = {
        starts_at: Time.now - 86400,
        ends_at: Time.now - 900,
        per_page: 50
      }.merge(options)

      Report.new(Transaction, "transactions/abandoned", options, page)
    end

    # Serialize the HTTP response into data.
    def self.load_from_response(response) # :nodoc:
      if response.success? and response.xml?
        load_from_xml Nokogiri::XML(response.body).css("transaction").first
      else
        Response.new Errors.new(response)
      end
    end

    # Serialize the XML object.
    def self.load_from_xml(xml) # :nodoc:
      new Serializer.new(xml).serialize
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

    private
    def after_initialize
      @errors = Errors.new
    end
  end
end
