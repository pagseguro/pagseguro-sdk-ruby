require_relative '../boot'

# Cancel a Subscription.
#
# You need to set your AccountCredentials (EMAIL, TOKEN) in the application
# config.
#
# P.S: See the boot file example for more details.

cancel = PagSeguro::SubscriptionCanceller.new(
  subscription_code: 'CODE',
)

cancel.credentials = PagSeguro::AccountCredentials.new('EMAIL', 'TOKEN')
cancel.save

if cancel.errors.any?
  puts '=> ERRORS'
  puts cancel.errors.join('\n')
else
  print '=> Subscription cancelled correctly.'
end
