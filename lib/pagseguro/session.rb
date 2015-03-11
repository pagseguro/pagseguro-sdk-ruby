module PagSeguro
  class Session
    include Extensions::MassAssignment

    # The session id.
    attr_accessor :id

    # Create a payment session.
    # Return a PagSeguro::Session instance.
    def self.create
      load_from_response Request.post("sessions")
    end

    # Serialize the HTTP response into data.
    def self.load_from_response(response) # :nodoc:
      if response.success? and response.xml?
        load_from_xml Nokogiri::XML(response.body).css("session").first
      else
        "error: #{response.inspect}"
      end
    end

    # Serialize the XML object.
    def self.load_from_xml(xml) # :nodoc:
      new Serializer.new(xml).serialize
    end
  end
end
