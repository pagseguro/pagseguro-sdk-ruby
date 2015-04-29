require_relative "boot"

# You have both options to instantiate application credentials:
# The first option above defaults to PagSeguro.app_id and PagSeguro.app_key config
# credentials = PagSeguro.application_credentials
# credentials.authorization_code = "authorization_code"
# or
# credentials = PagSeguro::ApplicationCredentials.new("app45", "1D4738", "authorization_code")
# transaction = PagSeguro::Transaction.find_by_notification_code("3D939", { credentials: credentials })

transaction = PagSeguro::Transaction.find_by_code("3D939")

puts transaction
