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
    # Return a PagSeguro::Installment::Collection instance
    def self.find(amount, card_brand = nil)
      params = RequestSerializer.new({ amount: amount, card_brand: card_brand })
        .to_params
      response = Request.get("installments", "v2", params)
      Collection.new Response.new(response).serialize
    end
  end
end
