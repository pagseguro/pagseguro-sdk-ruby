module PagSeguro
  class Document
    include Extensions::MassAssignment

    # Set the type.
    attr_accessor :type

    # Set the value.
    attr_accessor :value

    def ==(other)
      type == other.type && value == other.value
    end
  end
end
