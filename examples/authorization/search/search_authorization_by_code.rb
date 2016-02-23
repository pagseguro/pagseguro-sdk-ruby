require_relative "../../boot"

# Search Authorization by Code
#
#   You need to give:
#     - authorization code
#     - application credentials (APP_ID, APP_KEY) OR account credentials (EMAIL, TOKEN)
#
#   You can pass these parameters to PagSeguro::Authorization#find_by_code
#
# PS: For more details take a look at the class PagSeguro::Authorization#find_by_code

# credentials = PagSeguro::AccountCredentials.new("EMAIL", "TOKEN")
credentials = PagSeguro::ApplicationCredentials.new("APP_ID", "APP_KEY")

options = { credentials: credentials } # Unnecessary if you set in application config

authorization = PagSeguro::Authorization.find_by_code('AUTHORIZATION_CODE', options)

if authorization.errors.any?
  puts authorization.errors.join("\n")
else
  authorization.permissions.each do |permission, index|
    puts "Permission #{index}: "
    puts "  code: #{permission.code}"
    puts "  status: #{permission.status}"
  end
  puts
end
