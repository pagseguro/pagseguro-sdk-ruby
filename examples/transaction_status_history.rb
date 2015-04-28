require_relative "boot"

response = PagSeguro::Transaction.find_status_history("transaction_code")

response.each do |status|
  puts "STATUS:"
  puts "  code: #{status.code}"
  puts "  date: #{status.date}"
  puts "  notification_code: #{status.notification_code}"
end
