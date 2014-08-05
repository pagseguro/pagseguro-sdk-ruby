require "bigdecimal"
require "forwardable"
require "time"

require "nokogiri"
require "aitch"
require "i18n"

require "pagseguro/version"
require "pagseguro/config"
require "pagseguro/errors"
require "pagseguro/exceptions"
require "pagseguro/extensions/mass_assignment"
require "pagseguro/extensions/ensure_type"
require "pagseguro/address"
require "pagseguro/shipping"
require "pagseguro/phone"
require "pagseguro/item"
require "pagseguro/items"
require "pagseguro/payment_method"
require "pagseguro/payment_request"
require "pagseguro/payment_request/serializer"
require "pagseguro/payment_request/response"
require "pagseguro/payment_status"
require "pagseguro/request"
require "pagseguro/report"
require "pagseguro/sender"
require "pagseguro/notification"
require "pagseguro/transaction"
require "pagseguro/transaction/response"
require "pagseguro/transaction/serializer"

I18n.load_path += Dir[File.expand_path("../../locales/*.yml", __FILE__)]

module PagSeguro
  class << self
    # Delegates some calls to the config object
    extend Forwardable
    def_delegators :configuration, :email, :receiver_email, :token
    def_delegators :configuration, :email=, :receiver_email=, :token=

    # The encoding that will be used.
    attr_accessor :encoding

    # The PagSeguro environment.
    # Only +production+ for now.
    attr_accessor :environment
  end

  self.encoding = "UTF-8"
  self.environment = :production

  # Register endpoints by environment.
  def self.uris
    @uris ||= {
      production: {
        api: "https://ws.pagseguro.uol.com.br/v2",
        site: "https://pagseguro.uol.com.br/v2"
      },
      test: {
        site: 'https://sandbox.pagseguro.uol.com.br/v2',
        api:  'https://ws.sandbox.pagseguro.uol.com.br/v2'
      }
    }
  end

  # Return the root uri based on its type.
  # Current types are <tt>:api</tt> or <tt>:site</tt>
  def self.root_uri(type)
    root = uris.fetch(environment.to_sym) { raise InvalidEnvironmentError }
    root[type.to_sym]
  end

  # The configuration intance for the thread
  def self.configuration
    Thread.current[:pagseguro_config] ||= PagSeguro::Config.new
  end

  # Set the global configuration.
  #
  #   PagSeguro.configure do |config|
  #     config.email = "john@example.com"
  #     config.token = "abc"
  #   end
  #
  def self.configure(&block)
    yield configuration
  end

  # The API endpoint.
  def self.api_url(path)
    File.join(root_uri(:api), path)
  end

  # The site url.
  def self.site_url(path)
    File.join(root_uri(:site), path)
  end
end
