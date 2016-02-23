# -*- encoding : utf-8 -*-
require_relative "../boot"

# Create Payment Request
#
# You need to set your AccountCredentials (EMAIL, TOKEN) in the application config
#
# P.S: See the boot file example for more details.

payment = PagSeguro::PaymentRequest.new
payment.abandon_url = "http://dev.simplesideias.com.br/?abandoned"
payment.notification_url = "http://dev.simplesideias.com.br/?notification"
payment.redirect_url = "http://dev.simplesideias.com.br/?redirect"

# If you don't want to use payment request credentials you can use application config
payment.credentials = PagSeguro::AccountCredentials.new('EMAIL', 'TOKEN')

payment.items << {
  id: 1234,
  description: %[Televisão 19" Sony],
  amount: 459.50,
  weight: 0
}

payment.reference = "REF1234"
payment.sender = {
  name: "Nando Vieira",
  email: "fnando.vieira@gmail.com",
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

# Add extras params to request
# payment.extra_params << { paramName: 'paramValue' }
# payment.extra_params << { senderBirthDate: '07/05/1981' }
# payment.extra_params << { extraAmount: '-15.00' }

puts "=> REQUEST"
puts PagSeguro::PaymentRequest::RequestSerializer.new(payment).to_params

response = payment.register

puts
puts "=> RESPONSE"
puts response.url
puts response.code
puts response.created_at
puts response.errors.to_a
