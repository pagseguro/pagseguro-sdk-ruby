module PagSeguro
  class Errors
    extend Forwardable
    include Enumerable

    def_delegators :@messages, :each, :empty?, :any?, :join, :include?

    def initialize(response = nil)
      @response = response
      @messages = []

      process(@response) if response
    end

    # Adds errors.
    # Accepts a response.
    def add(response)
      process(response)
    end

    private
    def process(response)
      @messages << error_message(:unauthorized, "Unauthorized") if response.unauthorized?
      @messages << error_message(:not_found, "Not found") if response.not_found?

      response.data.css("errors > error").each do |error|
        @messages << error_message(error.css("code").text, error.css("message").text)
      end if response.bad_request?
    end

    def error_message(code, message)
      I18n.t(code, scope: "pagseguro.errors", default: message)
    end
  end
end
