require_relative "boot"

payment = PagSeguro::BoletoTransactionRequest.new
payment.notification_url = "http://www.meusite.com.br/notification"
payment.payment_mode = "default"

payment.items << {
  id: 1234,
  description: %[Televisão 19" Sony],
  amount: 459.50,
  weight: 0
}

payment.reference = "REF1234-boleto"
payment.sender = {
  hash: "7e215170790948f45e26175c2192c77e88c0e4c361a5860b99d2e9a97af982e6",
  name: "Joao Comprador",
  email: "joao@sandbox.pagseguro.com.br",
  cpf: "75073461100",
  phone: {
    area_code: 11,
    number: "12345678"
  }
}

payment.shipping = {
  type_name: "sedex",
  address: {
    street: "Av. Brig. Faria Lima",
    number: "1384",
    complement: "5º andar",
    city: "São Paulo",
    state: "SP",
    district: "Jardim Paulistano",
    postal_code: "01452002"
  }
}


# Add extras params to request
# payment.extra_params << { paramName: 'paramValue' }
# payment.extra_params << { senderBirthDate: '07/05/1981' }

puts "=> REQUEST"
puts PagSeguro::TransactionRequest::Serializer.new(payment).to_params
puts

response = payment.register

if response.errors.any?
  puts "=> ERRORS"
  puts response.errors.to_a
else
  puts "=> RESPONSE"
  puts response.payment_link
  puts response.code
  puts response.created_at
end
