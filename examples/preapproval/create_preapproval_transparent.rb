require_relative '../boot'

# Create a Subscription Plan (Transparent Checkout).
#
# You need to set your AccountCredentials (EMAIL, TOKEN) in the application config
#
# P.S: See the boot file example for more details.

email = 'EMAIL'
token = 'TOKEN'

plan = PagSeguro::SubscriptionPlan.new(
  charge: 'auto',

  redirect_url: 'http://www.lojateste.com.br/redirect',
  review_url: 'http://www.lojateste.com.br/review',

  name: 'Test',
  period: 'Monthly',
  amount: 100.0,
  max_total_amount: 2400.0,
  final_date: Time.new(2017, 2, 28, 20, 20),
  membership_fee: 150.0,
  trial_duration: 28,
)

# Edit the lines above.

plan.credentials = PagSeguro::AccountCredentials.new(email, token)
plan.create

if plan.errors.any?
  puts '=> ERRORS'
  puts plan.errors.join('\n')
else
  print '=> Subscription Plan correct created, its code is '
  puts plan.code

  puts %[=> Now you need to subscribe your client to this plan (see
examples/preapproval/create_preapproval.rb).]
end
