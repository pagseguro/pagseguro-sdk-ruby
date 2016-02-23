module PagSeguro
  module Request
    extend self
    extend Forwardable

    # Delegates the <tt>:config</tt> and <tt>:configure</tt> methods
    # to the <tt>:request</tt> method, which returns a Aitch::Namespace instance.
    def_delegators :request, :config, :configure

    # Perform a GET request.
    #
    # # +path+: the path that will be requested. Must be something like <tt>"transactions/code/739D69-79C052C05280-55542D9FBB33-CAB2B1"</tt>.
    # # +api_version+: the current PagSeguro API version of the requested service
    # # +data+: the data that will be sent as query string. Must be a Hash.
    # # +headers+: any additional header that will be sent through the request.
    #
    def get(path, api_version, data = {}, headers = {})
      execute :get, path, api_version, data, headers
    end

    # Perform a POST request.
    #
    # # +path+: the path that will be requested. Must be something like <tt>"checkout"</tt>.
    # # +api_version+: the current PagSeguro API version of the requested service
    # # +data+: the data that will be sent as body data. Must be a Hash.
    # # +headers+: any additional header that will be sent through the request.
    #
    def post(path, api_version, data = {}, headers = {})
      execute :post, path, api_version, data, headers
    end

    # Perform a POST request, sending XML data.
    #
    # # +path+: the path that will be requested. Must be something like <tt>"checkout"</tt>.
    # # +api_version+: the current PagSeguro API version of the requested service
    # # +credentials+: the credentials like ApplicationCredentials or AccountCredentials.
    # # +data+: the data that will be sent as body data. Must be a XML.
    #
    def post_xml(path, api_version, credentials, data)
      credentials_params = credentials_to_params(credentials)

      request.post do
        url PagSeguro.api_url("#{api_version}/#{path}?#{credentials_params}")
        headers "Content-Type" => "application/xml; charset=#{PagSeguro.encoding}"
        body data
      end
    end

    # Perform the specified HTTP request. It will include the API credentials,
    # api_version, encoding and additional headers.
    def execute(request_method, path, api_version, data, headers) # :nodoc:
      request.public_send(
        request_method,
        PagSeguro.api_url("#{api_version}/#{path}"),
        extended_data(data),
        extended_headers(request_method, headers)
      )
    end

    private
    def request
      @request ||= Aitch::Namespace.new
    end

    def extended_data(data)
      if data[:credentials]
        data.merge!(credentials_object(data))
      else
        data.merge!(global_credentials(data))
      end
      data.merge!({ charset: PagSeguro.encoding })
      data.delete_if { |_, value| value.nil? }
    end

    def extended_headers(request_method, headers)
      headers.merge __send__("headers_for_#{request_method}")
    end

    def headers_for_post
      {
        "Accept-Charset" => PagSeguro.encoding,
        "Content-Type" => "application/x-www-form-urlencoded; charset=#{PagSeguro.encoding}"
      }
    end

    def headers_for_get
      {
        "Accept-Charset" => PagSeguro.encoding
      }
    end

    def credentials_to_params(credentials)
      credentials_object(credentials: credentials)
        .delete_if { |_, value| value.nil? }
        .map { |key, value| "#{key}=#{value}" }
        .join('&')
    end

    def credentials_object(data)
      credentials = data.delete(:credentials)
      if credentials.respond_to? :app_id
        {
          appId: credentials.app_id,
          appKey: credentials.app_key,
          authorizationCode: credentials.authorization_code
        }
      else
        {
          email: credentials.email,
          token: credentials.token
        }
      end
    end

    def global_credentials(data)
      if PagSeguro.app_id && PagSeguro.app_key
        {
          appId: PagSeguro.app_id,
          appKey: PagSeguro.app_key
        }
      else
        {
          email: data[:email] || PagSeguro.email,
          token: data[:token] || PagSeguro.token
        }
      end
    end
  end

  Request.configure do |config|
    config.default_headers = {
      "lib-description"             => "ruby:#{PagSeguro::VERSION}",
      "language-engine-description" => "ruby:#{RUBY_VERSION}"
    }
  end
end
