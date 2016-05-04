module PagSeguro
  class SubscriptionSearch
    # Set the report options.
    #
    # # +per_page+: the page size.
    # # +starts_at+: the report's starting date. Can't be older than 6 months.
    # # +ends_at+: the report's ending date. Can't be greater than 30 days from the starting date.
    #
    attr_reader :options

    # Set the errors from the report request.
    attr_reader :errors

    # Return the current page.
    attr_reader :page

    def initialize(path, options)
      @path = path
      @page = options.delete(:page) || 0
      @options = options
      @errors = Errors.new
    end

    # Return the list of subscriptions.
    # Each item will be wrapped in a PagSeguro::Subscription instance.
    # Notice that subscriptions instantiated by the report won't have all attributes.
    # If you need additional attributes, do a PagSeguro::Subscription.find_by_code
    # call. Remember that this will perform an additional HTTP request.
    def subscriptions
      xml do |xml|
        xml.css("preApprovalSearchResult > preApprovals > preApproval").map do |node|
          Subscription.load_from_xml(node)
        end
      end
    end

    # The report's creation date.
    def created_at
      xml do |xml|
        @created_at ||= Time.parse xml.css("preApprovalSearchResult > date").text
      end
    end

    # How many results the report returned on the given page.
    def results
      xml do |xml|
        @results = xml.css("preApprovalSearchResult > resultsInThisPage").text.to_i
      end
    end

    # How many pages the report returned.
    def total_pages
      xml do |xml|
        @total_pages ||= xml.css("preApprovalSearchResult > totalPages").text.to_i
      end
    end

    # Detect if the report has a next page.
    def next_page?
      page.zero? || page < total_pages
    end

    # Detect if the report has a previous page.
    def previous_page?
      page > 1
    end

    # Move the page pointer to the next page.
    def next_page!
      return unless next_page?
      @page += 1
      clear!
    end

    # Move the page pointer to the previous page.
    def previous_page!
      return unless previous_page?
      @page -= 1
      clear!
    end

    # Detect if the report request returned errors.
    def valid?
      fetch { errors.empty? }
    end

    private
    def perform_request_and_serialize
      @response = Request.get(@path, api_version, params)
      @errors = Errors.new(@response)
    end

    # The params that will be sent
    def params
      {}.tap do |param|
        param[:credentials] = options[:credentials]
        param[:page] = page unless page.zero?
        param[:maxPageResults] = options[:per_page]
        param[:initialDate] = options[:starts_at].xmlschema if options[:starts_at]
        param[:finalDate] = options[:ends_at].xmlschema if options[:ends_at]
        param[:interval] = options[:interval] if options[:interval]
      end
    end

    # The default PagSeguro API version
    def api_version
      :v2
    end

    def fetched?
      @fetched
    end

    def fetched!
      @fetched = true
    end

    def clear!
      @fetched = false
    end

    def fetch(&block)
      unless fetched?
        perform_request_and_serialize
        fetched!
      end

      instance_eval(&block)
    end

    def xml(&block)
      valid? && block.call(@response.data)
    end
  end
end
