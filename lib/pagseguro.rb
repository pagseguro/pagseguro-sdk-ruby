require "bigdecimal"
require "forwardable"

require "nokogiri"
require "aitch"

require "pagseguro/errors"
require "pagseguro/extensions/mass_assignment"
require "pagseguro/extensions/ensure_type"
require "pagseguro/address"
require "pagseguro/shipping"
require "pagseguro/phone"
require "pagseguro/item"
require "pagseguro/items"
require "pagseguro/payment_request"
require "pagseguro/payment_request/serializer"
require "pagseguro/payment_request/response"
require "pagseguro/request"
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
      }
    }
  end

  # Return the root uri based on its type.
  # Current types are <tt>:api</tt> or <tt>:site</tt>
  def self.root_uri(type)
    root = uris.fetch(environment.to_sym) { raise InvalidEnvironmentError }
    root[type.to_sym]
  end

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

  # The API endpoint.
  def self.api_url(path)
    File.join(root_uri(:api), path)
  end

  # The site url.
  def self.site_url(path)
    File.join(root_uri(:site), path)
  end
end
