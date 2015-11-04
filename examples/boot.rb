$:.unshift File.expand_path("../../lib", __FILE__)
require "pagseguro"

I18n.locale = "pt-BR"

PagSeguro.configure do |config|
  # You can setup with Application Credentials trough TOKEN and EMAIL
  #   config.token = ENV.fetch("PAGSEGURO_TOKEN")
  #   config.email = ENV.fetch("PAGSEGURO_EMAIL")
  #
  # OR with Application Credentials through APP_ID and APP_KEY
  #   config.app_id = ENV.fetch("PAGSEGURO_APP_ID")
  #   config.app_key = ENV.fetch("PAGSEGURO_APP_KEY")
  #
  #
  # Ps: You can set the credentials when you to call some service like:
  #   For Account credentials based on EMAIL and TOKEN
  #     - PagSeguro::ApplicationCredentials.new("appteste_1", "TESTE11111")
  #
  #   OR
  #
  #   For Application credentials based on APP_KEY and APP_ID
  #     - PagSeguro::AccountCredentials.new("user@example.com", "token")

  config.environment = :sandbox
end
