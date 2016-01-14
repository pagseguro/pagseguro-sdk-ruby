module PagSeguro
  class Transaction
    ONE_DAY_IN_SECONDS = 86400
    FIFTEEN_MINUTES_IN_SECONDS = 900

    include Extensions::MassAssignment
    include Extensions::EnsureType
    include Extensions::Credentiable

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

    # The charged fees.
    attr_reader :creditor_fees

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
    def self.find_by_code(code, options = {})
      load_from_response send_request("transactions/#{code}", options)
    end

    # Find a transaction by its notificationCode.
    # Return a PagSeguro::Transaction instance.
    def self.find_by_notification_code(code, options = {})
      load_from_response send_request("transactions/notifications/#{code}", options)
    end

    # Find a transaction by status.
    # Return a PagSeguro::Transaction::Colletion.
    def self.find_status_history(code)
      request = send_request("transactions/#{code}/statusHistory")
      collection = StatusCollection.new
      Response.new(request, collection).serialize_statuses

      collection
    end

    # Search transactions within a date range.
    # Return a PagSeguro::SearchByDate instance
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
        starts_at: Time.now - ONE_DAY_IN_SECONDS,
        ends_at: Time.now,
        per_page: 50
      }.merge(options)
      SearchByDate.new("transactions", options, page)
    end

    # Search a transaction by its reference code
    # Return a PagSeguro::SearchByReference instance
    #
    # Options:
    #
    # # +reference+: the transaction reference code
    #
    def self.find_by_reference(reference, options = {})
      SearchByReference.new("transactions", { reference: reference }.merge(options))
    end

    # Get abandoned transactions.
    # Return a PagSeguro::SearchByDate instance
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
        starts_at: Time.now - ONE_DAY_IN_SECONDS,
        ends_at: Time.now - FIFTEEN_MINUTES_IN_SECONDS,
        per_page: 50
      }.merge(options)

      SearchAbandoned.new("transactions/abandoned", options, page)
    end

    # Normalize creditor fees object
    def creditor_fees=(creditor_fees)
      @creditor_fees = ensure_type(CreditorFee, creditor_fees)
    end

    # Normalize the sender object.
    def sender=(sender)
      @sender = ensure_type(Sender, sender)
    end

    # Normalize the shipping object.
    def shipping=(shipping)
      @shipping = ensure_type(Shipping, shipping)
    end

    # Hold the transaction's payments
    def payment_releases
      @payment_releases ||= PaymentReleases.new
    end

    # Normalize the transaction's payments list
    def payment_releases=(_payments)
      _payments.each { |payment| payment_releases << payment }
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

    # Set errors.
    def errors
      @errors ||= Errors.new
    end

    # Update all attributes
    def update_attributes(attrs)
      attrs.each { |name, value| send("#{name}=", value) }
    end

    # Serialize the XML object.
    def self.load_from_xml(xml) # :nodoc:
      new Serializer.new(xml).serialize
    end

    private
    def self.api_version
      'v3'
    end

    def after_initialize
      @errors = Errors.new
    end

    # Serialize the HTTP response into data.
    def self.load_from_response(request) # :nodoc:
      transaction = new
      response = Response.new(request, transaction)
      response.serialize

      transaction
    end

    # Send a get request to v3 API version, with the path given
    def self.send_request(path, options = {})
      Request.get(path, api_version, options)
    end
  end
end
