require_relative "boot"

transaction = PagSeguro::Transaction.find_by_notification_code("Invalid")

if transaction.errors.any?
  puts transaction.errors.join("\n")
else
  puts transaction
end
