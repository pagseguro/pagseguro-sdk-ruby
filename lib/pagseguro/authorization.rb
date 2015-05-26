module PagSeguro
  class Authorization
    include Extensions::MassAssignment
    include Extensions::Credentiable

    # The authorization code
    attr_accessor :code

    # The authorization creation date
    attr_accessor :created_at

    # The reference related to the authorization
    attr_accessor :reference

    # The authorization permissions
    attr_accessor :permissions

    # Find an authorization by it's notification code
    def self.find_by_notification_code(code, options = {})
      request = Request.get("authorizations/notifications/#{code}", options)
      new(Response.new(request).serialize)
    end

    # Find an authorization by it's code
    def self.find_by_code(code, options = {})
      request = Request.get("authorizations/#{code}", options)
      new(Response.new(request).serialize)
    end
  end
end
