module PagSeguro
  class SubscriptionChangeStatus
    include Extensions::MassAssignment
    include Extensions::Credentiable

    # Now, just available ACTIVE and SUSPENDED
    STATUSES = {
      active: 'ACTIVE',
      suspended: 'SUSPENDED'
    }

    # Subscription's code that will be changed
    attr_reader :code

    # The status that will be set
    attr_reader :status

    def initialize(code, status)
      @code = code
      @status = status
    end

    # Set errors
    def errors
      @errors ||= Errors.new
    end

    def save
      request = Request.put_xml("pre-approvals/#{code}/status", credentials, params)

      Response.new(request, self).serialize

      self
    end

    def status_text
      STATUSES[status]
    end

    private

    def params
      RequestSerializer.new(self).serialize
    end

    def after_initialize
      @errors = Errors.new
    end
  end
end
