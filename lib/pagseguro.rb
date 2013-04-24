require "bigdecimal"
require "forwardable"

require "pagseguro/extensions/mass_assignment"
require "pagseguro/extensions/ensure_type"
require "pagseguro/address"
require "pagseguro/shipping"
require "pagseguro/phone"
require "pagseguro/item"
require "pagseguro/items"
require "pagseguro/payment_request"
require "pagseguro/payment_request/serializer"
require "pagseguro/http_request"
require "pagseguro/http_response"
require "pagseguro/sender"
require "pagseguro/version"

module PagSeguro
  class << self
    # Primary e-mail associated with this account.
    attr_accessor :email

    # The e-mail that will be displayed when sender is redirected
    # to PagSeguro.
    attr_accessor :receiver_email

    # The API token associated with this account.
    attr_accessor :token

    # The API endpoint.
    attr_accessor :endpoint

    # The encoding that will be used.
    attr_accessor :encoding

    # The PagSeguro environment.
    # Only +production+ for now.
    attr_accessor :environment
  end

  self.endpoint = "https://ws.pagseguro.uol.com.br/v2"
  self.encoding = "UTF-8"
  self.environment = "production"

  # Set the global configuration.
  #
  #   PagSeguro.configure do |config|
  #     config.email = "john@example.com"
  #     config.token = "abc"
  #   end
  #
  def self.configure(&block)
    yield self
  end
end
