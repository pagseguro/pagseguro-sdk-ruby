module PagSeguro
  class PreApproval
    include Extensions::MassAssignment
    include Extensions::EnsureType

    attr_accessor :name 
    attr_accessor :code
    attr_accessor :date 
    attr_accessor :tracker
    attr_accessor :status
    attr_accessor :last_event_date
    attr_accessor :reference
    attr_accessor :charge

    attr_reader :sender

    # Set the pre approval errors.
    attr_reader :errors

    # Find a pre approval by its code
    # Return a PagSeguro::PreApproval instance
    def self.find_by_code(code)
      load_from_response Request.get("pre-approvals/#{code}")
    end

    # Find a pre approval by its notificationCode.
    # Return a PagSeguro::PreApproval instance.
    def self.find_by_notification_code(code)
      load_from_response Request.get("pre-approvals/notifications/#{code}")

    end

    # Serialize the HTTP response into data.
    def self.load_from_response(response) # :nodoc:
      if response.success? and response.xml?
        load_from_xml Nokogiri::XML(response.body).css("preApproval").first
      else
        Response.new Errors.new(response)
      end
    end

    # Serialize the XML object.
    def self.load_from_xml(xml) # :nodoc:
      new Serializer.new(xml).serialize
    end

     # Normalize the sender object.
    def sender=(sender)
      @sender = ensure_type(Sender, sender)
    end

    private
    def after_initialize
      @errors = Errors.new
    end
  end
end