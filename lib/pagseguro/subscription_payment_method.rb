module PagSeguro
  class SubscriptionPaymentMethod
    include Extensions::MassAssignment
    include Extensions::EnsureType

    # Set the token
    attr_accessor :token

    # Get the holder
    attr_reader :holder

    # Set the holder
    def holder=(holder)
      @holder = ensure_type(PagSeguro::Holder, holder)
    end

    def type
      'CREDITCARD'
    end
  end
end
