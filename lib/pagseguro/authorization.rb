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

    PERMISSIONS = {
      checkouts: 'CREATE_CHECKOUTS',
      notifications: 'RECEIVE_TRANSACTION_NOTIFICATIONS',
      searches: 'SEARCH_TRANSACTIONS',
      pre_approvals: 'MANAGE_PAYMENT_PRE_APPROVALS',
      payments: 'DIRECT_PAYMENTS'
    }

    def self.authorize(options, notification_url, redirect_url)
      authorization = new(options)
      params = Serializer.new(authorization, notification_url, redirect_url).to_params
      Response.new Request.post('/authorizations/request', params)
    end

    private
    def before_initialize
      self.app_id = PagSeguro.app_id
      self.app_key = PagSeguro.app_key
      self.permissions = PERMISSIONS.keys
    end
  end
end
