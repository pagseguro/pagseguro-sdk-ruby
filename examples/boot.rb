$:.unshift File.expand_path("../../lib", __FILE__)
require "pagseguro"

I18n.locale = "pt-BR"

PagSeguro.configure do |config|
  config.token = ENV.fetch("PAGSEGURO_TOKEN")
  config.email = ENV.fetch("PAGSEGURO_EMAIL")
  config.app_id = ENV.fetch("PAGSEGURO_APP_ID")
  config.app_key = ENV.fetch("PAGSEGURO_APP_KEY")
  config.environment = :sandbox
end
