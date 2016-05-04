require_relative '../boot'

# Create a Subscription Plan (Manual charge)
#
# You need to set your AccountCredentials (EMAIL, TOKEN) in the application config
#
# P.S: See the boot file example for more details.

email = 'EMAIL'
token = 'TOKEN'

plan = PagSeguro::SubscriptionPlan.new(
  charge: 'manual', # Manual Subscription Plan must always use manual charge type.
  redirect_url: 'http://www.lojateste.com.br/redirect',
  review_url: 'http://www.lojateste.com.br/review',
  reference: 'REFERENCE',

  sender: {
    name: 'Nome do Cliente',
    email: 'client@example.com',
    phone: { area_code: 11, number: 123456 },
    address: {
      street: 'Av Brigadeira Faria Lima',
      number: '1384',
      complement: '3 andar',
      district: 'Jd Paulistano',
      city: 'Sao Paulo',
      state: 'SP',
      country: 'BRA',
      postal_code: '01452002'
    }
  },

  name: 'Insurance',
  details: 'Payment of 100.',
  amount: 100.0,
  period: 'Monthly',
  max_payments_per_period: 2,
  max_amount_per_period: 200.0,
  initial_date: Time.new(2016, 4, 19, 0, 0),
  final_date: Time.new(2017, 1, 1, 0, 0),
  max_total_amount: 2_400.0
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
  puts '=> And your client can finish the subscription using this url:'
  puts plan.url
end
