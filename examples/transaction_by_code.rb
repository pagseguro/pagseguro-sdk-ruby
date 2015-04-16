require_relative "boot"

# credentials = PagSeguro::Credentials.new("app45", "1D4738", "authorization_code")
# transaction = PagSeguro::Transaction.find_by_notification_code("3D939", { credentials: credentials })

transaction = PagSeguro::Transaction.find_by_code("3D939")

puts transaction
