require_relative "boot"

# app_id defaults to PagSeguro.app_id
# app_key defaults to PagSeguro.app_key
# permissions defaults to all permissions
# notification_url is a required param
# redirect_url is a required param

options = {
  app_id: ENV.fetch("PAGSEGURO_APP_ID"),
  app_key: ENV.fetch("PAGSEGURO_APP_KEY"),
  permissions: [:searches, :notifications],
  notification_url: 'foo.com.br',
  redirect_url: 'bar.com.br'
}
response = PagSeguro::Authorization.new(options).authorize

puts "=> Response"
puts response.code
puts response.created_at
