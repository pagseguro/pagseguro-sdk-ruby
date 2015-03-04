module PagSeguro
  class Installment
    include Extensions::MassAssignment

    # Set the amount
    attr_accessor :amount

    # Set the credit card brand
    attr_accessor :credit_card_brand
  end
end
