require "simplecov"
SimpleCov.start

require "bundler/setup"
Bundler.require(:default, :development)

require "test_notifier/runner/rspec"
require "fakeweb"
require "pagseguro"

FakeWeb.allow_net_connect = false

Dir["./spec/support/**/*.rb"].each {|file| require file }

RSpec.configure do |config|
  config.before(:each) do
    load "./lib/pagseguro.rb"
  end
end
