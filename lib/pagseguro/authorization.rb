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
      request = Request.get("authorizations/notifications/#{code}", "v2", options)
      authorization = PagSeguro::Authorization.new
      Response.new(request, authorization).serialize

      authorization
    end

    # Find an authorization by it's code
    def self.find_by_code(code, options = {})
      request = Request.get("authorizations/#{code}", "v2", options)
      authorization = PagSeguro::Authorization.new
      Response.new(request, authorization).serialize

      authorization
    end

    def self.find_by_date(options)
      request = Request.get("authorizations", "v2", RequestSerializer.new(options).to_params)
      collection = Collection.new
      Response.new(request, collection).serialize_collection

      collection
    end

    def update_attributes(attrs)
      attrs.map { |name, value| send("#{name}=", value) }
    end

    def errors
      @errors ||= Errors.new
    end
  end
end
