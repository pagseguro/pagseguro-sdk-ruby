require_relative "boot"

permissions = [:searches, :notifications]
response = PagSeguro::Authorization.authorize('foo.com.br', 'bar.com.br', permissions)

puts "=> Response"
puts response.code
puts response.created_at
