module PagSeguro
  class SearchByReference < PagSeguro::Search
    private
    def perform_request_and_serialize
      @response = Request.get(@path, api_version,
        {
          reference: options[:reference],
          credentials: (options[:credentials] if options.has_key? :credentials)
        })
      @errors = Errors.new(@response)
    end
  end
end
