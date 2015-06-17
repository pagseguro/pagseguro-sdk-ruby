module PagSeguro
  class Session
    include Extensions::MassAssignment

    # The session id.
    attr_accessor :id

    # The PageSeguro::Errors object.
    attr_writer :errors

    def errors
      @errors ||= Errors.new
    end

    # Create a payment session.
    # Return a PagSeguro::Session instance.
    def self.create
      response = Request.post("sessions", "v2")
      session = Session.new
      response = Response.new(response, session).serialize

      session
    end

    def update_attributes(attrs)
      attrs.map { |name, value| send("#{name}=", value) }
    end
  end
end
