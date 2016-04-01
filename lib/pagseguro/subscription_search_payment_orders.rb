module PagSeguro
  class SubscriptionSearchPaymentOrders
    attr_reader :code
    attr_reader :options
    attr_reader :status
    attr_reader :errors
    attr_reader :page

    def initialize(code, status, options={})
      @code = code
      @status = status
      @options = options
      @page = options.delete(:page) || 0
      @errors = Errors.new
    end

    # Return the list of subscription payment orders.
    # Each item will be wrapped in a PagSeguro::SubscriptionPaymentOrder instance.
    def payment_orders
      xml do |xml|
        xml.css("paymentOrdersResult > paymentOrders > paymentOrder").map do |node|
          SubscriptionPaymentOrder.load_from_xml(node)
        end
      end
    end

    # The report's creation date.
    def created_at
      xml do |xml|
        @created_at ||= Time.parse xml.css("paymentOrdersResult > date").text
      end
    end

    # How many results the report returned on the given page.
    def results
      xml do |xml|
        @results = xml.css("paymentOrdersResult > resultsInThisPage").text.to_i
      end
    end

    # How many pages the report returned.
    def total_pages
      xml do |xml|
        @total_pages ||= xml.css("paymentOrdersResult > totalPages").text.to_i
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
      @response = Request.get_without_api_version(path, params, header)
      @errors = Errors.new(@response)
    end

    def path
      PagSeguro.api_url "pre-approvals/#{code}/payment-orders"
    end

    def header
      { "Accept" => "application/vnd.pagseguro.com.br.v1+xml;charset=ISO-8859-1" }
    end

    # The params that will be sent
    def params
      {}.tap do |param|
        param[:status] = SubscriptionPaymentOrder::STATUSES[status.to_sym]
        param[:page] = page
        param[:maxPageResults] = options[:per_page]
        param[:credentials] = options[:credentials]
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
