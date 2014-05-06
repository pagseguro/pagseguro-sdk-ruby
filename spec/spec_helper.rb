require "simplecov"
SimpleCov.start

require "bundler/setup"
Bundler.require(:default, :development)

I18n.enforce_available_locales = false
require "test_notifier/runner/rspec"
require "fakeweb"
require "pagseguro"

FakeWeb.allow_net_connect = false

Dir["./spec/support/**/*.rb"].each {|file| require file }

I18n.exception_handler = proc do |scope, *args|
  message = scope.to_s
  raise message unless message.include?(".i18n.plural.rule")
end

I18n.default_locale = "pt-BR"
I18n.locale = ENV.fetch("LOCALE", I18n.default_locale)

RSpec.configure do |config|
  config.before(:each) do
    load "./lib/pagseguro.rb"
    FakeWeb.clean_registry
  end
end
