module PagSeguro
  class SubscriptionCanceller
    API_VERSION = :v2

    include Extensions::MassAssignment
    include Extensions::Credentiable

    # The code of subscription, not the plan
    attr_accessor :subscription_code

    # Set errors
    def errors
      @errors ||= Errors.new
    end

    def save
      request = Request.get_with_auth_on_url("pre-approvals/cancel/#{subscription_code}", API_VERSION, credentials)

      Response.new(request, self).serialize

      self
    end

    private

    def after_initialize
      @errors = Errors.new
    end
  end
end
