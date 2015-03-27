module PagSeguro
  class Authorization
    PERMISSIONS_SYMBOLS = %i(checkouts notifications searches pre_approvals payments)
    PERMISSIONS = {
      checkouts: 'CREATE_CHECKOUTS',
      notifications: 'RECEIVE_TRANSACTION_NOTIFICATIONS',
      searches: 'SEARCH_TRANSACTIONS',
      pre_approvals: 'MANAGE_PAYMENT_PRE_APPROVALS',
      payments: 'DIRECT_PAYMENTS'
    }

    def self.authorize(credentials, permissions = PERMISSIONS_SYMBOLS)
      permissions = set_permissions(permissions)
      Request.post('/authorizations/request', 'v2', permissions)
    end

    private
    def self.set_permissions(permissions)
      permissions.map { |value| PERMISSIONS[value] }.join(',')
    end
  end
end
