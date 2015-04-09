module PagSeguro
  class Notification
    include PagSeguro::Extensions::MassAssignment

    # The notification code sent by PagSeguro.
    attr_accessor :code

    # The notification type sent by PagSeguro.
    attr_accessor :type
  end
end
