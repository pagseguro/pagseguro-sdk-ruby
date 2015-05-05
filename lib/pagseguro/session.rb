module PagSeguro
  class Session
    # Create a payment session.
    # Return a PagSeguro::Session::Response instance.
    def self.create
      Response.new(Request.post("sessions", "v2")).parse
    end
  end
end
