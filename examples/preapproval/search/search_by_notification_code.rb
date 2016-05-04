require_relative '../../boot'

# Find a Subscription by notification code
#
# You need to give AccountCredentials (EMAIL, TOKEN) and the notification code
#
# P.S: See the boot file example for more details.

email = 'user@example.com'
token = 'TOKEN'
code = 'NOTIFICATION_CODE'

credentials = PagSeguro::AccountCredentials.new(email, token)
subscription = PagSeguro::Subscription.find_by_notification_code(code, credentials: credentials)

if subscription.errors.empty?
  puts "Subscription:"
  puts "  code: #{subscription.code}"
  puts "  name: #{subscription.name}"
  puts "  date: #{subscription.date}"
  puts "  tracker: #{subscription.tracker}"
  puts "  status: #{subscription.status}"
  puts "  reference: #{subscription.reference}"
  puts "  last event date: #{subscription.last_event_date}"
  puts "  charge: #{subscription.charge}"

  if subscription.sender
    puts "  sender.name: #{subscription.sender.name}"
    puts "  sender.email: #{subscription.sender.email}"

    if subscription.sender.phone
      puts "  sender.phone.area_code: #{subscription.sender.phone.area_code}"
      puts "  sender.phone.number: #{subscription.sender.phone.number}"
    end

    if subscription.sender.address
      puts "  sender.address.street: #{subscription.sender.address.street}"
      puts "  sender.address.number: #{subscription.sender.address.number}"
      puts "  sender.address.complement: #{subscription.sender.address.complement}"
      puts "  sender.address.district: #{subscription.sender.address.district}"
      puts "  sender.address.city: #{subscription.sender.address.city}"
      puts "  sender.address.state: #{subscription.sender.address.state}"
      puts "  sender.address.postal_code: #{subscription.sender.address.postal_code}"
      puts "  sender.address.country: #{subscription.sender.address.country}"
    end
  end
else
  puts "Errors:"
  puts subscription.errors.join("\n")
end
