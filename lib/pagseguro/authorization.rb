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

    private
    def before_initialize
      self.app_id = PagSeguro.app_id
      self.app_key = PagSeguro.app_key
      self.permissions = PERMISSIONS.keys
    end
  end
end
