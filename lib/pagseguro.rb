require "bigdecimal"
require "forwardable"
require "time"

require "nokogiri"
require "aitch"
require "i18n"

require "pagseguro/extensions/mass_assignment"
require "pagseguro/extensions/ensure_type"
require "pagseguro/extensions/credentiable"

require "pagseguro/authorization"
require "pagseguro/authorization/report"
require "pagseguro/authorization/serializer"
require "pagseguro/authorization/response"
require "pagseguro/account_credentials"
require "pagseguro/application_credentials"
require "pagseguro/version"
require "pagseguro/config"
require "pagseguro/errors"
require "pagseguro/exceptions"
require "pagseguro/address"
require "pagseguro/shipping"
require "pagseguro/phone"
require "pagseguro/installment"
require "pagseguro/installment/response"
require "pagseguro/installment/serializer"
require "pagseguro/item"
require "pagseguro/items"
require "pagseguro/payment_method"
require "pagseguro/payment_request"
require "pagseguro/payment_request/serializer"
require "pagseguro/payment_request/response"
require "pagseguro/payment_status"
require "pagseguro/permission"
require "pagseguro/request"
require "pagseguro/report"
require "pagseguro/sender"
require "pagseguro/notification"
require "pagseguro/notification/authorization"
require "pagseguro/notification/transaction"
require "pagseguro/transaction"
require "pagseguro/transaction/response"
require "pagseguro/transaction/serializer"

I18n.load_path += Dir[File.expand_path("../../locales/*.yml", __FILE__)]

module PagSeguro
  class << self
    # Delegates some calls to the config object
    extend Forwardable
    def_delegators :configuration, :email, :receiver_email, :token,
      :environment, :encoding, :app_id, :app_key

    def email=(email)
      warn "[DEPRECATION] `email=` is deprecated and will be removed. Please use configuration block instead."
      configuration.email = email
    end

    def receiver_email=(receiver_email)
      warn "[DEPRECATION] `receiver_email=` is deprecated and will be removed. Please use configuration block instead."
      configuration.receiver_email = receiver_email
    end

    def token=(token)
      warn "[DEPRECATION] `token=` is deprecated and will be removed. Please use configuration block instead."
      configuration.token = token
    end

    def environment=(environment)
      warn "[DEPRECATION] `environment=` is deprecated and will be removed. Please use configuration block instead."
      configuration.environment = environment
    end

    def encoding=(encoding)
      warn "[DEPRECATION] `encoding=` is deprecated and will be removed. Please use configuration block instead."
      configuration.encoding = encoding
    end
  end

  # Register endpoints by environment.
  def self.uris
    @uris ||= {
      production: {
        api: "https://ws.pagseguro.uol.com.br/v2",
        site: "https://pagseguro.uol.com.br/v2"
      },
      sandbox: {
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

  # The configuration instance
  def self.configuration
    @configuration ||= PagSeguro::Config.new
  end

  # Set the global configuration.
  #
  #   PagSeguro.configure do |config|
  #     config.email = "john@example.com"
  #     config.token = "abc"
  #     config.app_id = "app12345"
  #     config.app_key = "adju3cmADc52C"
  #     config.environment = :sandbox
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
