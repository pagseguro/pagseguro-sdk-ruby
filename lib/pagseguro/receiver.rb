module PagSeguro
  class Receiver
    include Extensions::MassAssignment
    include Extensions::EnsureType

    # Set receiver's email.
    attr_accessor :email

    # Get receiver split.
    attr_reader :split

    # Set receiver split.
    def split=(split)
      @split = ensure_type(ReceiverSplit, split)
    end
  end
end
