require_relative "boot"

# app_id defaults to PagSeguro.app_id
# app_key defaults to PagSeguro.app_key
# permissions defaults to all permissions

options = {
  app_id: ENV.fetch("PAGSEGURO_APP_ID"),
  app_key: ENV.fetch("PAGSEGURO_APP_KEY"),
  permissions: [:searches, :notifications]
}
response = PagSeguro::Authorization.authorize(options,'foo.com.br', 'bar.com.br')

puts "=> Response"
puts response.code
puts response.created_at
