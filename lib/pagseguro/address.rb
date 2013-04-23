module PagSeguro
  # Set the shipping address information.
  class Address
    include Extensions::MassAssignment

    # Set the street name.
    attr_accessor :street

    # Set the house/building number.
    attr_accessor :number

    # Set the address complement.
    # Can be the apartment, suite number or any other qualifier after
    # the street/number pair.
    attr_accessor :complement

    # Set the district.
    # Can be the district, county or neighborhood, if applicable.
    attr_accessor :district

    # Set the city name.
    attr_accessor :city

    # Set the state or province.
    attr_accessor :state

    # Set the postal code.
    # Must contain 8 numbers.
    attr_accessor :postal_code

    # Set the country code.
    # Defaults to +BRA+.
    attr_accessor :country

    private
    def before_initialize
      self.country = "BRA"
    end
  end
end
