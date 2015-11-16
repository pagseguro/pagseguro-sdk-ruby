require_relative "../boot"

# Authorization by notification code
#
#   You need to give:
#     - authorization code
#     - application credentials (APP_ID, APP_KEY)
#
#   You can pass this parameters to PagSeguro::Authorization#find_by_notification_code
#
# PS: For more details look the class PagSeguro::Authorization#find_by_notification_code


credentials = PagSeguro::ApplicationCredentials.new('APP_ID', 'APP_KEY')

options = { credentials: credentials } # Unnecessary if you set in application config

authorization = PagSeguro::Authorization.find_by_notification_code('NOTIFICATION_CODE', options)

puts authorization.errors.inspect

if authorization.errors.any?
  puts authorization.errors.join("\n")
else
  authorization.permissions.each do |permission|
    puts "Permission: "
    puts permission.code
    puts permission.status
  end
end
