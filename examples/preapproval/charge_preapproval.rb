require_relative '../boot'

# Charge a Manual Subscription.
#
# You also can set your AccountCredentials (EMAIL, TOKEN) in the application
# config.
#
# See the boot file example for more details.

email = 'EMAIL'
token = 'TOKEN'

charger = PagSeguro::ManualSubscriptionCharger.new(
  reference: 'REFERENCE',
  subscription_code: 'SUBSCRIPTION_CODE',
)

charger.items << {
  id: '0001',
  description: 'Seguro contra roubo',
  amount: 100.0,
  quantity: 1
}

# Edit the lines above.

charger.credentials = PagSeguro::AccountCredentials.new(email, token)
charger.create

if charger.errors.any?
  puts '=> ERRORS'
  puts charger.errors.join("\n")
else
  print '=> Subscription was corrected charged, the transaction code is '
  puts charger.transaction_code
end
