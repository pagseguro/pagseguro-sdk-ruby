module PagSeguro
  class Session
    include Extensions::MassAssignment

    # The session id.
    attr_accessor :id

    def self.create
      Request.post("sessions")
    end
  end
end
