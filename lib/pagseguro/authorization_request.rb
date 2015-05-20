module PagSeguro
  class AuthorizationRequest
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
      payments: 'DIRECT_PAYMENT',
      refunds: 'REFUND_TRANSACTIONS',
      cancels: 'CANCEL_TRANSACTIONS'
    }

    def create
      params = RequestSerializer.new(self).to_params
      request = Request.post('authorizations/request', params)
      new AuthorizationResponse.new(request).serialize
    end


    private
    def before_initialize
      self.permissions = PERMISSIONS.keys
    end
  end
end
