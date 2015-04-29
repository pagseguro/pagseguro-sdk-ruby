require_relative "boot"

# You have both options to instantiate account credentials:
# The first option above defaults to PagSeguro.app_id and PagSeguro.app_key config
# credentials = PagSeguro.account_credentials
# or
# credentials = PagSeguro::AccountCredentials.new("user@example.com", "token")

# transaction = PagSeguro::Transaction.find_by_notification_code("3D939", { credentials: credentials })

transaction = PagSeguro::Transaction.find_by_notification_code("3D939")

puts transaction
