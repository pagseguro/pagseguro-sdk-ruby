require_relative '../boot'

# Cancel a Subscription.
#
# You need to set your AccountCredentials (EMAIL, TOKEN) in the application
# config.
#
# P.S: See the boot file example for more details.

code = 'CODE'
email = 'EMAIL'
token = 'TOKEN'

# Edit the lines above.

cancel = PagSeguro::SubscriptionCanceller.new(subscription_code: code)

cancel.credentials = PagSeguro::AccountCredentials.new(email, token)
cancel.save

if cancel.errors.any?
  puts '=> ERRORS'
  puts cancel.errors.join('\n')
else
  print '=> Subscription cancelled correctly.'
end
