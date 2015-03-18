module PagSeguro
  class Document
    include Extensions::MassAssignment

    # Set the type.
    attr_accessor :type

    # Set the value.
    attr_accessor :value
  end
end
