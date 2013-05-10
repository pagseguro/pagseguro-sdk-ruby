$:.unshift File.expand_path("../../lib", __FILE__)
require "pagseguro"

I18n.locale = "pt-BR"

PagSeguro.configure do |config|
  config.token = ENV.fetch("PAGSEGURO_TOKEN")
  config.email = ENV.fetch("PAGSEGURO_EMAIL")
end
