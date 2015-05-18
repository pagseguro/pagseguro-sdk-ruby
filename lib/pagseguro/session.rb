module PagSeguro
  class Session
    include Extensions::MassAssignment

    # The session id.
    attr_accessor :id

    attr_writer :errors

    def errors
      @errors ||= Errors.new
    end

    # Create a payment session.
    # Return a PagSeguro::Session instance.
    def self.create
      response = Request.post("sessions", "v2")
      new Response.new(response).serialize
    end
  end
end
