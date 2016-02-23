require_relative "../../boot"

# Search Transaction Status History
#
# You need to set your credentials in the application config
#
# P.S: See the boot file example for more details

response = PagSeguro::Transaction.find_status_history("transaction_code")

puts response.inspect

if response.errors.any?
  puts response.errors.join("\n")
else
  response.each do |status|
    puts "STATUS:"
    puts "  code: #{status.code}"
    puts "  date: #{status.date}"
    puts "  notification_code: #{status.notification_code}"
  end
end
