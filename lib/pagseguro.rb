require "bigdecimal"
require "forwardable"
require "time"

require "nokogiri"
require "aitch"
require "i18n"

require "pagseguro/extensions/mass_assignment"
require "pagseguro/extensions/ensure_type"
require "pagseguro/extensions/credentiable"
require "pagseguro/extensions/collection_object"

require "pagseguro/version"
require "pagseguro/config"

require "pagseguro/account_credentials"
require "pagseguro/application_credentials"
require "pagseguro/authorization"
require "pagseguro/authorization/collection"
require "pagseguro/authorization/request_serializer"
require "pagseguro/authorization/response_serializer"
require "pagseguro/authorization/response"
require "pagseguro/authorization_request"
require "pagseguro/authorization_request/request_serializer"
require "pagseguro/authorization_request/response_serializer"
require "pagseguro/authorization_request/response"
require "pagseguro/creditor_fee"
require "pagseguro/errors"
require "pagseguro/exceptions"
require "pagseguro/address"
require "pagseguro/document"
require "pagseguro/documents"
require "pagseguro/shipping"
require "pagseguro/phone"
require "pagseguro/phones"
require "pagseguro/person"
require "pagseguro/partner"
require "pagseguro/company"
require "pagseguro/account"
require "pagseguro/installment"
require "pagseguro/installment/collection"
require "pagseguro/installment/response"
require "pagseguro/installment/response_serializer"
require "pagseguro/installment/request_serializer"
require "pagseguro/item"
require "pagseguro/items"
require "pagseguro/bank"
require "pagseguro/holder"
require "pagseguro/payment_method"
require "pagseguro/payment_release"
require "pagseguro/payment_releases"
require "pagseguro/payment_request"
require "pagseguro/payment_request/request_serializer"
require "pagseguro/payment_request/response"
require "pagseguro/payment_status"
require "pagseguro/permission"
require "pagseguro/request"
require "pagseguro/transaction_refund"
require "pagseguro/transaction_refund/request_serializer"
require "pagseguro/transaction_refund/response"
require "pagseguro/transaction_refund/response_serializer"
require "pagseguro/receiver"
require "pagseguro/receiver_split"
require "pagseguro/sender"
require "pagseguro/session"
require "pagseguro/session/response"
require "pagseguro/session/response_serializer"
require "pagseguro/notification"
require "pagseguro/notification/authorization"
require "pagseguro/notification/transaction"
require "pagseguro/transaction"
require "pagseguro/transaction_status"
require "pagseguro/transaction/response"
require "pagseguro/transaction/serializer"
require "pagseguro/transaction/collection"
require "pagseguro/transaction/status_collection"
require "pagseguro/transaction_cancellation"
require "pagseguro/transaction_cancellation/request_serializer"
require "pagseguro/transaction_cancellation/response"
require "pagseguro/transaction_cancellation/response_serializer"
require "pagseguro/transaction/search"
require "pagseguro/transaction/search/search_by_date"
require "pagseguro/transaction/search/search_by_reference"
require "pagseguro/transaction/search/search_abandoned"
require "pagseguro/transaction_installment"
require "pagseguro/transaction_request"
require "pagseguro/transaction_request/response"
require "pagseguro/transaction_request/response_serializer"
require "pagseguro/transaction_request/request_serializer"
require "pagseguro/boleto_transaction_request"
require "pagseguro/online_debit_transaction_request"
require "pagseguro/credit_card_transaction_request"

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

  # Returns an object with the configured account credentials
  def self.account_credentials
    PagSeguro::AccountCredentials.new(PagSeguro.email, PagSeguro.token)
  end

  # Returns an object with the configured application credentials
  def self.application_credentials
    PagSeguro::ApplicationCredentials.new(PagSeguro.app_id, PagSeguro.app_key)
  end

  # Register endpoints by environment.
  def self.uris
    @uris ||= {
      production: {
        api: "https://ws.pagseguro.uol.com.br/",
        site: "https://pagseguro.uol.com.br/"
      },
      sandbox: {
        site: 'https://sandbox.pagseguro.uol.com.br/',
        api:  'https://ws.sandbox.pagseguro.uol.com.br/'
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
