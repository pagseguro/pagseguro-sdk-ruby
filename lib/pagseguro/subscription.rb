module PagSeguro
  # It lets you create a subscription without going through PagSeguro screens.
  class Subscription
    include Extensions::MassAssignment
    include Extensions::EnsureType
    include Extensions::Credentiable

    API_VERSION = :v2
    TEN_DAYS_IN_SECONDS = 864_000

    # Set the name
    attr_accessor :name

    # Set the date
    attr_accessor :date

    # Set the tracker
    attr_accessor :tracker

    # Set the status
    attr_accessor :status

    # Set the last event date
    attr_accessor :last_event_date

    # Set the charge
    attr_accessor :charge

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

    # Find subscription by notification code
    def self.find_by_notification_code(code, options={})
      load_from_response send_request("pre-approvals/notifications/#{code}", options[:credentials])
    end

    # Find subscription by subscription code
    def self.find_by_code(code, options={})
      load_from_response send_request("pre-approvals/#{code}", options[:credentials])
    end

    def self.search_by_days_interval(options={})
      # Default options
      options = {
        interval: 30,
        per_page: 50,
        page: 0
      }.merge(options)

      SubscriptionSearch.new('pre-approvals/notifications', options)
    end

    def self.search_by_date_interval(options={})
      # Default options
      options = {
        starts_at: Time.now,
        ends_at: Time.now - TEN_DAYS_IN_SECONDS,
        per_page: 50,
        page: 0
      }.merge(options)

      SubscriptionSearch.new('pre-approvals', options)
    end

    def self.load_from_xml(xml)
      new ResponseSerializer.new(xml).serialize_from_search
    end

    private

    # Serialize the HTTP response into data.
    def self.load_from_response(request) # :nodoc:
      subscription = new
      Response.new(request, subscription).serialize(:search)

      subscription
    end

    # Send a get request to API version, with the path given
    def self.send_request(path, credentials)
      Request.get_with_auth_on_url(path, API_VERSION, credentials)
    end

    def xml_params
      RequestSerializer.new(self).serialize
    end

    def extra_options
      { headers: { "Accept" => "application/vnd.pagseguro.com.br.v1+xml;charset=ISO-8859-1" }}
    end

    def after_initialize
      @errors = Errors.new
    end
  end
end
