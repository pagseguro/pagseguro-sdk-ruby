require_relative '../boot'

# Create a Subscription
#
# You need to set your AccountCredentials (EMAIL, TOKEN) in the application config
#
# P.S: See the boot file example for more details.

subscription = PagSeguro::Subscription.new(
  plan: '7E3A9C989999E49AS4D29FAC5D4B910G',
  reference: 'SUB-1234',
  sender: {
    name: 'Comprador',
    email: 'user@sandbox.pagseguro.com.br',
    ip: '192.168.0.1',
    hash: 'hash',
    phone: {
      area_code: 12,
      number: '23456789'
    },
    document: { type: 'CPF', value: '23606838450' },
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
  payment_method: {
    token: 'eb3d3d40e0b344d1aeadf9c2375d016f',
    holder: {
      name: 'Nome',
      birth_date: '11/01/1984',
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
      },
      phone: { area_code: '11', number: '988881234' }
    }
  }
)

subscription.credentials = PagSeguro::AccountCredentials.new('EMAIL', 'TOKEN')
subscription.create

if subscription.errors.any?
  puts '=> ERRORS'
  puts subscription.errors.join('\n')
else
  print '=> Subscription correct created, its code is '
  puts subscription.code
end
