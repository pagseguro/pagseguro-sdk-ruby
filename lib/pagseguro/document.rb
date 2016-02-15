module PagSeguro
  class Document
    include Extensions::MassAssignment

    # Set the type.
    attr_accessor :type

    # Set the value.
    attr_accessor :value

    def ==(other)
      [type, value] == [other.type, other.value]
    end
  end
end
