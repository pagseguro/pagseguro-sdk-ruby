$:.unshift File.expand_path("../../lib", __FILE__)
require "pagseguro"

I18n.locale = "pt-BR"

PagSeguro.environment = :sandbox

PagSeguro.configure do |config|
  config.token = ENV.fetch("PAGSEGURO_TOKEN") { "FBA1D3AED5DC476185082686E21B1CB8" }
  config.email = ENV.fetch("PAGSEGURO_EMAIL") { "contato@lucasrenan.com" }
end
