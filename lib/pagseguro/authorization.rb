module PagSeguro
  class Authorization
    include Extensions::MassAssignment
    include Extensions::Credentiable

    # The permissions given to the application
    # Defaults to all permissions
    attr_accessor :permissions

    # The seller reference (optional)
    attr_accessor :reference

    # The url which PagSeguro can send notifications
    attr_accessor :notification_url

    # The url which the application is going to be redirected after the proccess
    attr_accessor :redirect_url

    PERMISSIONS = {
      checkouts: 'CREATE_CHECKOUTS',
      notifications: 'RECEIVE_TRANSACTION_NOTIFICATIONS',
      searches: 'SEARCH_TRANSACTIONS',
      pre_approvals: 'MANAGE_PAYMENT_PRE_APPROVALS',
      payments: 'DIRECT_PAYMENTS'
    }

    def authorize
      params = Serializer.new(self).to_params
      Response.new Request.post('authorizations/request', params)
    end

    # Find an authorization by it's notification code
    def self.find_by_notification_code(code, options = {})
      load_from_response Request.get("authorizations/notifications/#{code}", options)
    end

    # Find an authorization by it's code
    def self.find_by_code(code, options = {})
      load_from_response Request.get("authorizations/#{code}", options)
    end

    # Serialize the HTTP response into data.
    def self.load_from_response(response) # :nodoc:
      if response.success? and response.xml?
        Report.new(Nokogiri::XML(response.body).css("authorization").first, Errors.new)
      else
        Report.new({}, Errors.new(response))
      end
    end

    private
    def before_initialize
      self.permissions = PERMISSIONS.keys
    end
  end
end
