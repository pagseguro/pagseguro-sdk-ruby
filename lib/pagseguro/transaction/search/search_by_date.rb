module PagSeguro
  class SearchByDate < PagSeguro::Search
    private
    def perform_request_and_serialize
      @response = Request.get(@path, api_version,
        {
          initialDate: options[:starts_at].xmlschema,
          finalDate: options[:ends_at].xmlschema,
          page: page,
          maxPageResults: options.fetch(:per_page, 50),
          credentials: options[:credentials]
        })
      @errors = Errors.new(@response)
    end
  end
end
