module PagSeguro
  class Phone
    include Extensions::MassAssignment

    # Set the area code.
    attr_accessor :area_code

    # Set the phone number.
    # Must have 7-9 numbers.
    attr_accessor :number
  end
end
