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
      return unless response.error?
      @messages << error_message(
        error_to_sym(response.error),
        error_to_human(response.error)
      )

      if response.error == Aitch::BadRequestError
        response.data.css("errors > error").each do |error|
          @messages << error_message(error.css("code").text, error.css("message").text)
        end
      end
    end

    def error_message(code, message)
      I18n.t(code, scope: "pagseguro.errors", default: message)
    end


    # Error formats
    def error_to_sym(error)
      error.to_s.split(/::/)[-1]
        .gsub(/Error$/, '')
        .gsub(/[[:upper:]]/)
        .with_index {|k, i| i == 0 ? k : ('_' + k)}
        .downcase
        .to_sym
    end

    def error_to_human(error)
      error_to_sym(error).to_s
        .capitalize
        .gsub('_', ' ')
    end
  end
end
