require_relative '../boot'

# Change a Payment.
#
# You need to set your AccountCredentials (EMAIL, TOKEN) in the application
# config.
#
# P.S: See the boot file example for more details.

email = 'EMAIL'
token = 'TOKEN'

new_payment = PagSeguro::SubscriptionChangePayment.new(
  subscription_code: 'SUBSCRIPTION_CODE',
  sender: {
    hash: 'HASH',
    ip: '192.168.0.1',
  },
  subscription_payment_method: {
    token: 'TOKEN',
    holder: {
      name: 'Nome',
      birth_date: Date.new(1984, 12, 31),
      phone: { area_code: '11', number: '988881234' },
      document: { type: 'CPF', value: '00000000191' },
      billing_address: {
        street: 'Av Brigadeira Faria Lima',
        number: '1384',
        complement: '3 andar',
        district: 'Jd Paulistano',
        city: 'Sao Paulo',
        state: 'SP',
        country: 'BRA',
        postal_code: '01452002'
      }
    }
  }
)

# Edit the lines above.

new_payment.credentials = PagSeguro::AccountCredentials.new(email, token)
new_payment.update

if new_payment.errors.any?
  puts '=> ERRORS'
  puts new_payment.errors.join("\n")
else
  print '=> Subscription correct changed.'
end
