module PagSeguro
  class Document
    include Extensions::MassAssignment

    # the type of the document
    attr_accessor :type

    # the value of the document
    attr_accessor :value
  end
end
