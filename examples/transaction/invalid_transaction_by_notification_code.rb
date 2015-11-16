require_relative "../boot"

# Invalid transaction by notification code
#
#   You need to give:
#     - notification code (invalid)
#     - account credentials (EMAIL, TOKEN) OR application credentials (APP_ID, APP_KEY)
#
#   You can pass this parameters to PagSeguro::Transaction#find_by_notification_code

# credentials = PagSeguro::ApplicationCredentials.new('APP_ID', 'APP_KEY')
credentials = PagSeguro::AccountCredentials.new('EMAIL', 'TOKEN')

options = { credentials: credentials } # Unnecessary if you set in application config

transaction = PagSeguro::Transaction.find_by_notification_code("Invalid", options)

if transaction.errors.any?
  puts transaction.errors.join("\n")
else
  puts transaction
end
