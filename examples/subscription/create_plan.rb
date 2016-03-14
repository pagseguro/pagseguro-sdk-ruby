require_relative '../boot'

# Create a Subscription Plan
#
# You need to set your AccountCredentials (EMAIL, TOKEN) in the application config
#
# P.S: See the boot file example for more details.

plan = PagSeguro::SubscriptionPlan.new(
  max_users: 10,
  name: 'Testing',
  charge: 'AUTO',
  amount: 80,
  max_amount: 35_000,
  final_date: Date.new(2017, 1, 1),
  membership_fee: 150,
  trial_duration: 28,
  period: 'MONTHLY'
)

plan.credentials = PagSeguro::AccountCredentials.new('EMAIL', 'TOKEN')
plan.create

if plan.errors.any?
  puts '=> ERRORS'
  puts plan.errors.join('\n')
else
  print '=> Subscription Plan correct created, its code is '
  puts plan.code
end
