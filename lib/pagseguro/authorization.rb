module PagSeguro
  class Authorization
    PERMISSIONS = {
      checkouts: 'CREATE_CHECKOUTS',
      notifications: 'RECEIVE_TRANSACTION_NOTIFICATIONS',
      searches: 'SEARCH_TRANSACTIONS',
      pre_approvals: 'MANAGE_PAYMENT_PRE_APPROVALS',
      payments: 'DIRECT_PAYMENTS'
    }

    def self.authorize(notification_url, redirect_url, permissions = PERMISSIONS)
      params = Serializer.new(notification_url, redirect_url, permissions).to_params
      Response.new Request.post('/authorizations/request', params)
    end
  end
end
