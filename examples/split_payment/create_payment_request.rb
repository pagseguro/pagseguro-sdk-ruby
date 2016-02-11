require_relative "../boot"

# Create Split Payment.
#
# You need to set your ApplicationCredentials (EMAIL, TOKEN) in the application
# config.
#
# P.S: See the boot file example for more details.

payment = PagSeguro::PaymentRequest.new
payment.abandon_url = "http://example.com/?abandoned"
payment.notification_url = "http://example.com/?notification"
payment.redirect_url = "http://example.com/?redirect"

# If you don't want to use the application config, you can give your credentials
# object to payment request.

payment.credentials = PagSeguro::ApplicationCredentials.new('APP_ID', 'APP_KEY')

payment.items << {
  id: 1234,
  description: %[Televisão 19" Sony],
  quantity: 1,
  amount: 459.50,
  shipping_cost: 0.0,
  weight: 0
}

payment.primary_receiver = 'primary.receiver@example.com'

payment.receivers = [
  {
    email: 'other.receiver@example.com',
    split: { amount: '400.00', },
  }
]

payment.reference = "REF1234"
payment.sender = {
  name: "Sender One",
  email: "sender@example.com",
  cpf: "21639716866",
  phone: {
    area_code: 11,
    number: "12345678"
  }
}

payment.shipping = {
  type_name: "sedex",
  address: {
    street: "R. Vergueiro",
    number: 1421,
    complement: "Sala 213",
    city: "São Paulo",
    state: "SP",
    district: "Vila Mariana"
  }
}

puts "=> REQUEST"
puts PagSeguro::PaymentRequest::RequestSerializer.new(payment).to_xml_params

response = payment.register

puts
puts "=> RESPONSE"
puts response.url
puts response.code
puts response.created_at
puts response.errors.to_a
