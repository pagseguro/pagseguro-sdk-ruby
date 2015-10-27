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

    # The code used to confirm the authorization
    attr_reader :code

    # The date of authorization creation
    attr_reader :date

    # Errors object.
    attr_writer :errors

    PERMISSIONS = {
      checkouts: 'CREATE_CHECKOUTS',
      notifications: 'RECEIVE_TRANSACTION_NOTIFICATIONS',
      searches: 'SEARCH_TRANSACTIONS',
      pre_approvals: 'MANAGE_PAYMENT_PRE_APPROVALS',
      payments: 'DIRECT_PAYMENT',
      refunds: 'REFUND_TRANSACTIONS',
      cancels: 'CANCEL_TRANSACTIONS'
    }

    # Post and create an Authorization.
    # Return Boolean.
    def create
      request = Request.post('authorizations/request', 'v2', params)
      response = Response.new(request)
      update_attributes(response.serialize)

      response.success?
    end

    # URL to confirm authorization after create one.
    def url
      PagSeguro.site_url("v2/authorization/request.jhtml?code=#{code}") if code
    end

    def errors
      @errors ||= Errors.new
    end

    private
    attr_writer :code, :date

    def before_initialize
      self.permissions = PERMISSIONS.keys
    end

    def params
      RequestSerializer.new(self).to_params
    end

    def update_attributes(attrs)
      attrs.each { |method, value| send("#{method}=", value) }
    end
  end
end
