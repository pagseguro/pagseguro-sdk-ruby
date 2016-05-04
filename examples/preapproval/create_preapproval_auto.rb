require_relative '../boot'

# Create a Subscription Plan (Auto charge)
#
# You need to set your AccountCredentials (EMAIL, TOKEN) in the application config
#
# P.S: See the boot file example for more details.

email = 'EMAIL'
token = 'TOKEN'

plan = PagSeguro::SubscriptionPlan.new(
  charge: 'auto', # Automatic Subscription Plan must always use auto charge type.

  redirect_url: 'http://www.lojateste.com.br/redirect',
  review_url: 'http://www.lojateste.com.br/review',
  reference: 'AUTOPLAN123',
  name: 'Seguro contra roubo do Notebook',
  details: 'Taxa referente ao seguro contra roubo de Notebook',
  period: 'Monthly',
  final_date: Time.new(2017, 2, 28, 20, 20),
  amount: 100.0,
  max_total_amount: 2400.0,

  sender: {
    name: 'Nome do Cliente',
    email: 'client@example.com',
    phone: { area_code: 11, number: 123456 },
    address: {
      street: 'Avenida Brigadeiro Faria Lima',
      number: 1384,
      complement: '1 Andar',
      district: 'Jardim Paulistano',
      postal_code: '01452002',
      city: 'São Paulo',
      state: 'SP',
      country: 'BRA',
    }
  }
)

# Edit the lines above.

plan.credentials = PagSeguro::AccountCredentials.new(email, token)
plan.create

if plan.errors.any?
  puts '=> ERRORS'
  puts plan.errors.join("\n")
else
  print '=> Subscription Plan correct created, its code is '
  puts plan.code
end
