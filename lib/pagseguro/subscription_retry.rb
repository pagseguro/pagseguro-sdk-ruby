module PagSeguro
  class SubscriptionRetry
    include Extensions::MassAssignment
    include Extensions::Credentiable

    attr_accessor :payment_order_code
    attr_accessor :subscription_code

    def errors
      @errors ||= Errors.new
    end

    def save
      request = Request.post_xml(url, nil, credentials, nil, extra_options)

      Response.new(request, self).serialize

      self
    end

    private

    def url
      "pre-approvals/#{subscription_code}/payment-orders/#{payment_order_code}/payment"
    end

    def extra_options
      { headers: { "Accept" => "application/vnd.pagseguro.com.br.v1+xml;charset=ISO-8859-1" }}
    end

    def after_initialize
      @errors = Errors.new
    end
  end
end
