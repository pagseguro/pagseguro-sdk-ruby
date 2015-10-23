module PagSeguro
  class TransactionInstallment
    include Extensions::MassAssignment

    # Set the installments value.
    attr_accessor :value

    # Set the installments quantity.
    attr_accessor :quantity
  end
end
