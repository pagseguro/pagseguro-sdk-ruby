module PagSeguro
  class Installment
    include Extensions::MassAssignment

    # Set the credit card brand.
    attr_accessor :card_brand

    # Set the installments quantity.
    attr_accessor :quantity

    # Set the amount.
    # Must fit the patern: \\d+.\\d{2} (e.g. "12.00")
    attr_accessor :amount

    # Set total amount.
    attr_accessor :total_amount

    # Set interest free.
    attr_accessor :interest_free

    attr_writer :errors

    def errors
      @errors ||= Errors.new
    end

    # Find installment options by a given amount
    # Optional. Credit card brand
    # Return an Array of PagSeguro::Installment instances
    def self.find(amount, card_brand = nil)
      string = "installments?amount=#{amount}"
      string += "&cardBrand=#{card_brand}" if card_brand

      response = Request.get(string, 'v2')
      Response.new(response).serialize
    end
  end
end
