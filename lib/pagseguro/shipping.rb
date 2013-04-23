module PagSeguro
  class Shipping
    # Set the available shipping type.
    TYPE = {
      pac: 1,
      sedex: 2,
      not_specified: 3
    }

    # Define the error class for invalid type assignment.
    InvalidShippingTypeError = Class.new(StandardError)

    include Extensions::MassAssignment
    include Extensions::EnsureType

    # Define the shipping type id.
    attr_reader :type_id

    # Get the shipping type name.
    attr_reader :type

    # Get the address object.
    attr_reader :address

    # Set the shipping cost.
    attr_accessor :cost

    # Set the shipping address info.
    def address=(address)
      @address = ensure_type(Address, address)
    end

    # Set the shipping type.
    # It raises the PagSeguro::Shipping::InvalidShippingTypeError exception
    # when trying to assign an invalid type name.
    def type=(type)
      type = type.to_sym
      @type_id = TYPE.fetch(type) {
        raise InvalidShippingTypeError, "invalid #{type.inspect} type name"
      }
      @type = type
    end

    # Set the shipping type id.
    # It raises the PagSeguro::Shipping::InvalidShippingTypeError exception
    # when trying to assign an invalid type id.
    def type_id=(id)
      type_id = id.to_i

      raise InvalidShippingTypeError,
        "invalid #{id.inspect} type id" unless TYPE.value?(type_id)

      @type_id = type_id
      @type = TYPE.key(type_id)
    end
  end
end
