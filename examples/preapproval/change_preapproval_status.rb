require_relative "../boot"

# Change Subscription Status
#
# You need to set:
#   - AccountCredentials (EMAIL, TOKEN)
#   - Subscription's code
#   - The new status
#
# P.S: Take a look at the boot file example for more details

user = 'user@example.com'
token = 'TOKEN'
code = 'CODE'
status = :suspended # Now just available the status :active and :suspended

credentials = PagSeguro::AccountCredentials.new('user@example.com', 'TOKEN')

change = PagSeguro::SubscriptionChangeStatus.new(code, status)
change.credentials = credentials
change.save

if change.errors.any?
  puts "ERRORS: "
  puts change.errors.inspect
else
  puts "SUCCESS"
  puts change.inspect
end
