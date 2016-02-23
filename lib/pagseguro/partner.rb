module PagSeguro
  class Partner
    include Extensions::MassAssignment

    attr_accessor :name

    # Pattern: aaaa-MM-dd
    attr_accessor :birth_date

    def documents
      @documents ||= Documents.new
    end

    def documents=(_documents=[])
      _documents.each do |document|
        documents << document
      end
    end
  end
end
