module PagSeguro
  class SubscriptionDiscount
    API_VERSION = :v2

    include Extensions::MassAssignment
    include Extensions::Credentiable

    # Type of discount, it can be DISCOUNT_PERCENT or DISCOUNT_AMOUNT.
    attr_accessor :type

    # Value of discount
    attr_accessor :value

    # The code of subscription, not the plan
    attr_accessor :code

    # Set errors
    def errors
      @errors ||= Errors.new
    end

    # The server returns only with a 200 response in case of success.
    def create
      request = Request.put_xml("pre-approvals/#{code}/discount", credentials, xml_params)

      Response.new(request, self).serialize

      self
    end

    private

    def after_initialize
      @errors = Errors.new
    end

    def xml_params
      RequestSerializer.new(self).to_xml_params
    end
  end
end
