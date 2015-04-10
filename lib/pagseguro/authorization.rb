module PagSeguro
  class Authorization
    include Extensions::MassAssignment

    # The application id
    attr_accessor :app_id

    # The token related to the application
    attr_accessor :app_key

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
      Response.new Request.post('/authorizations/request', params)
    end

    # Find an authorization by it's notification code
    def self.find_by_notification_code(options = {}, code)
      load_from_response Request.get("/authorizations/notifications/#{code}", options)
    end

    # Serialize the HTTP response into data.
    def self.load_from_response(response) # :nodoc:
      if response.success? and response.xml?
        load_from_xml Nokogiri::XML(response.body).css("authorization").first
      else
        Response.new Errors.new(response)
      end
    end

    # Serialize the XML object.
    def self.load_from_xml(xml) # :nodoc:
      new Report.new(xml).serialize
    end

    private
    def before_initialize
      self.app_id = PagSeguro.app_id
      self.app_key = PagSeguro.app_key
      self.permissions = PERMISSIONS.keys
    end
  end
end
