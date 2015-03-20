module PagSeguro
  class Session
    include Extensions::MassAssignment

    # The session id.
    attr_accessor :id

    # Set the transaction errors.
    attr_reader :errors

    # Create a payment session.
    # Return a PagSeguro::Session instance.
    def self.create
      load_from_response Request.post("sessions", "v2")
    end

    # Serialize the HTTP response into data.
    def self.load_from_response(response) # :nodoc:
      if response.success? and response.xml?
        load_from_xml Nokogiri::XML(response.body).css("session").first
      else
        Response.new Errors.new(response)
      end
    end

    # Serialize the XML object.
    def self.load_from_xml(xml) # :nodoc:
      new Serializer.new(xml).serialize
    end

    private
    def after_initialize
      @errors = Errors.new
    end
  end
end
