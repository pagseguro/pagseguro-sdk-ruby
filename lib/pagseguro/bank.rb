module PagSeguro
  class Bank
    include Extensions::MassAssignment

    # Set the bank name.
    attr_accessor :name
  end
end
