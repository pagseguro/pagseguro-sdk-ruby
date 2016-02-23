require_relative "../boot"

# Create Authorization with Account
#
#   You need to give:
#     - notification_url
#     - redirect_url
#     - permissions defaults to all permissions
#     - application credentials (APP_ID, APP_KEY)
#     - account params
#
#   You can pass these parameters to PagSeguro::AuthorizationRequest#new
#
# PS: For more details take a look at the class PagSeguro::AuthorizationRequest

credentials = PagSeguro::ApplicationCredentials.new('APP_ID', 'APP_KEY')

options = {
  credentials: credentials, # Unnecessary if you set in application config
  permissions: [:checkouts, :searches, :notifications],
  notification_url: 'http://seusite.com.br/redirect',
  redirect_url: 'http://seusite.com.br/notification',
  reference: '123',
  account: {
    email: 'usuario@seusite.com.br',
    type: 'SELLER',
    person: {
      name: 'Antonio Carlos',
      birth_date: Date.new(1982, 2, 5),
      address: {
        postal_code: '01452002',
        street: 'Av. Brig. Faria Lima',
        number: '1384',
        complement: '5o andar',
        district: 'Jardim Paulistano',
        city: 'Sao Paulo',
        state: 'SP',
        country: 'BRA'
      },
      documents: [{type: 'CPF', value: '23606838450'}],
      phones: [
        {type: 'HOME', area_code: '11', number: '30302323'},
        {type: 'MOBILE', area_code: '11', number: '976302323'},
      ]
    }
  }
}

authorization_request = PagSeguro::AuthorizationRequest.new(options)

if authorization_request.create
  print "Use this link to confirm authorizations: "
  puts authorization_request.url
else
  puts authorization_request.errors.join("\n")
end
