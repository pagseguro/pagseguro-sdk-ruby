require "simplecov"
SimpleCov.start

require "bundler/setup"
Bundler.require(:default, :development)

require "test_notifier/runner/rspec"
require "pagseguro"

Dir["./spec/support/**/*.rb"].each {|file| require file }
