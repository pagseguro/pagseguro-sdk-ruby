module PagSeguro
  class Phone
    include Extensions::MassAssignment

    # Set the type phone
    # Must be HOME, MOBILE or BUSINESS
    attr_accessor :type

    # Set the area code.
    attr_accessor :area_code

    # Set the phone number.
    # Must have 7-9 numbers.
    attr_accessor :number

    def ==(other)
      type == other.type && area_code == other.area_code && number == other.number
    end
  end
end
