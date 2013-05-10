module PagSeguro
  module Request
    extend self
    extend Forwardable

    def_delegators :request, :config, :configure

    def get(path, data = {}, headers = {})
      execute :get, path, data, headers
    end

    def post(path, data = {}, headers = {})
      execute :post, path, data, headers
    end

    def execute(request_method, path, data, headers)
      request.public_send(
        request_method,
        PagSeguro.api_url(path),
        extended_data(data),
        extended_headers(headers)
      )
    end

    private
    def request
      @request ||= Aitch::Namespace.new
    end

    def extended_data(data)
      data.merge(
        email: PagSeguro.email,
        token: PagSeguro.token,
        charset: PagSeguro.encoding
      )
    end

    def extended_headers(headers)
      headers.merge(
        "Accept-Charset" => "UTF-8",
        "Content-Type" => "application/x-www-form-urlencoded; charset=#{PagSeguro.encoding}"
      )
    end
  end

  Request.configure do |config|
    config.default_headers = {
      "lib-description"             => "ruby:#{PagSeguro::VERSION}",
      "language-engine-description" => "ruby:#{RUBY_VERSION}"
    }
  end
end
