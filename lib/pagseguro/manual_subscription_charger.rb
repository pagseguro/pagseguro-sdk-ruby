module PagSeguro
  class ManualSubscriptionCharger
    include Extensions::Credentiable
    include Extensions::EnsureType
    include Extensions::MassAssignment

    API_VERSION = :v2

    # Set reference
    attr_accessor :reference

    # Set subscription code of a manual subscription
    attr_accessor :subscription_code

    # Set transaction code, it is within the response
    attr_accessor :transaction_code

    # Set items
    attr_reader :items

    # Set errors
    def errors
      @errors ||= Errors.new
    end

    def items=(items=[])
      @items = items.map do |item|
                 ensure_type(Item, item)
               end
    end

    # Update all attributes
    def update_attributes(attrs)
      attrs.each { |name, value| send("#{name}=", value) }
    end

    def create
      request = Request.post_xml('pre-approvals/payment', API_VERSION, credentials, xml_params)

      Response.new(request, self).serialize

      self
    end

    private

    def xml_params
      RequestSerializer.new(self).to_xml_params
    end

    def before_initialize
      @items ||= Items.new
    end

    def after_initialize
      @errors = Errors.new
    end
  end
end
