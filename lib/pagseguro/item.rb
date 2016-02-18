module PagSeguro
  class Item
    include Extensions::MassAssignment

    # Set the product identifier, such as SKU.
    attr_accessor :id

    # Set the product description.
    attr_accessor :description

    # Set the quantity.
    # Defaults to 1.
    attr_accessor :quantity

    # Set the amount per unit.
    attr_accessor :amount

    # Set the weight per unit, in grams.
    attr_accessor :weight

    # Set the shipping cost per unit.
    attr_accessor :shipping_cost

    def ==(other)
      [id, description, amount] == [other.id, other.description, other.amount]
    end

    private
    def before_initialize
      self.quantity = 1
      self.weight = 0
    end
  end
end
