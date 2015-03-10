module PagSeguro
  class Session
    include Extensions::MassAssignment

    # The session id.
    attr_accessor :id
  end
end
