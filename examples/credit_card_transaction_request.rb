require_relative "boot"

payment = PagSeguro::CreditCardTransactionRequest.new
payment.notification_url = "http://www.meusite.com.br/notification"
payment.payment_mode = "gateway"

payment.items << {
  id: 1234,
  description: %[Televisão 19" Sony],
  amount: 459.50,
  weight: 0
}

payment.reference = "REF1234-credit-card"
payment.sender = {
  hash: "f8d95a0747cdddf277a111ec1bab1d68628e095243b7a56382ec01f260216313",
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

payment.billing_address = {
  street: "Av. Brig. Faria Lima",
  number: "1384",
  complement: "5º andar",
  city: "São Paulo",
  state: "SP",
  district: "Jardim Paulistano",
  postal_code: "01452002"
}

payment.credit_card_token = "41c1f784216748ccae689fcd854aaca1"
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

puts "=> REQUEST"
puts PagSeguro::TransactionRequest::Serializer.new(payment).to_params
puts

response = payment.register

if response.errors.any?
  puts "=> ERRORS"
  puts response.errors.to_a
else
  puts "=> RESPONSE"
  puts response.code
  puts response.created_at

  puts
  puts response.inspect
end
