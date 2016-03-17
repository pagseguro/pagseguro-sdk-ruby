require_relative '../boot'

# Create a Subscription Plan (Manual charge)
#
# You need to set your AccountCredentials (EMAIL, TOKEN) in the application config
#
# P.S: See the boot file example for more details.

plan = PagSeguro::SubscriptionPlan.new(
  max_users: 10,
  name: 'Testing',
  charge: 'MANUAL', # Manual Subscription Plan must always use manual charge type.
  amount: 80.0,
  max_amount: 35_000,
  max_amount_per_period: 100,
  final_date: Date.new(2017, 1, 1),
  membership_fee: 150.0,
  trial_duration: 28,
  period: 'Monthly'
)

plan.credentials = PagSeguro::AccountCredentials.new('EMAIL', 'TOKEN')
plan.create

if plan.errors.any?
  puts '=> ERRORS'
  puts plan.errors.join('\n')
else
  print '=> Subscription Plan correct created, its code is '
  puts plan.code
  puts '=> And your client can finish the subscription using this url:'
  puts plan.url
end
