require_relative "boot"

payment = PagSeguro::TransactionRequest.new
payment.notification_url = "http://www.meusite.com.br/notification"
payment.payment_method = "creditCard"
payment.payment_mode = "gateway"

payment.items << {
  id: 1234,
  description: %[Televisão 19" Sony],
  amount: 459.50,
  weight: 0
}

payment.reference = "REF1234"
payment.sender = {
  hash: "0db5776271490042a3b89f7f54d7e54244cf74d469695aa67c49e11c8a56c2c4",
  name: "Joao Comprador",
  email: "joao@comprador.com.br",
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

payment.billing_address = {
  street: "Av. Brig. Faria Lima",
  number: "1384",
  complement: "5º andar",
  city: "São Paulo",
  state: "SP",
  district: "Jardim Paulistano",
  postal_code: "01452002"
}

payment.credit_card_token = "286ff355747941f58b2093608cd6b7a2"
payment.holder = {
  name: "João Comprador",
  birth_date: "07/05/1981",
  document: {
    type: "CPF",
    value: "00000000191"
  },
  phone: {
    area_code: 11,
    number: "123456789"
  }
}

payment.installment = {
  value: 459.50,
  quantity: 1
}

# Add extras params to request
# payment.extra_params << { paramName: 'paramValue' }
# payment.extra_params << { senderBirthDate: '07/05/1981' }
# payment.extra_params << { extraAmount: '-15.00' }

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
