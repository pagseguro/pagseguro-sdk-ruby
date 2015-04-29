require_relative "boot"

# credentials have app_id and app_key infos
# permissions defaults to all permissions
# notification_url is a required param
# redirect_url is a required param

# You have both options to instantiate application credentials:
# The first option above defaults to PagSeguro.app_id and PagSeguro.app_key config
# credentials = PagSeguro.application_credentials
# or
# credentials = PagSeguro::ApplicationCredentials.new("app45", "1D4738")
options = {
  credentials: credentials,
  permissions: [:searches, :notifications],
  notification_url: 'foo.com.br',
  redirect_url: 'bar.com.br'
}

response = PagSeguro::Authorization.new(options).authorize

puts "=> Response"
puts response.code
puts response.created_at

puts "Use this link to confirm authorizations:"
puts "  link: #{response.url}"
