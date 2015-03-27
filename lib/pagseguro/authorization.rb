module PagSeguro
  class Authorization
    def self.authorize(credentials, permissions = nil)
      Request.post('/authorizations/request', 'v2')
    end
  end
end
