module PagSeguro
  class Authorization
    def self.authorize(notification_url, redirect_url, permissions = nil)
      params = Serializer.new(notification_url, redirect_url, permissions).to_params
      Response.new Request.post('/authorizations/request', params)
    end
  end
end
