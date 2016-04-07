require_relative "../boot"

# Retry a subscription payment.
#
# P.S: Take a look at the boot file example for more details

email = 'EMAIL'
token = 'TOKEN'
subscription_code = 'CODE'
payment_order_code = 'PAYMENT'

# Edit the lines above

credentials = PagSeguro::AccountCredentials.new(email, token)

subscription_retry = PagSeguro::SubscriptionRetry.new(
  subscription_code: subscription_code,
  payment_order_code: payment_order_code
)
subscription_retry.credentials = credentials
subscription_retry.save

if subscription_retry.errors.any?
  puts "ERRORS: "
  puts subscription_retry.errors.inspect
else
  puts "SUCCESS"
  puts subscription_retry.inspect
end
