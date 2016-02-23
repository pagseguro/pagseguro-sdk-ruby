require_relative "../boot"

# Create Transaction Using Credit Card
#
# You need to set your AccountCredentials (EMAIL, TOKEN) in the application config
#
# P.S: See the boot file example for more details.

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
puts PagSeguro::TransactionRequest::RequestSerializer.new(payment).to_params
puts

payment.create

if payment.errors.any?
  puts "=> ERRORS"
  puts payment.errors.join("\n")
else
  puts "=> Transaction"
  puts "  code: #{payment.code}"
  puts "  reference: #{payment.reference}"
  puts "  type: #{payment.type_id}"
  puts "  payment link: #{payment.payment_link}"
  puts "  status: #{payment.status}"
  puts "  payment method type: #{payment.payment_method}"
  puts "  created at: #{payment.created_at}"
  puts "  updated at: #{payment.updated_at}"
  puts "  gross amount: #{payment.gross_amount.to_f}"
  puts "  discount amount: #{payment.discount_amount.to_f}"
  puts "  net amount: #{payment.net_amount.to_f}"
  puts "  extra amount: #{payment.extra_amount.to_f}"
  puts "  installment count: #{payment.installment_count}"

  puts "    => Items"
  puts "      items count: #{payment.items.size}"
  payment.items.each do |item|
    puts "      item id: #{item.id}"
    puts "      description: #{item.description}"
    puts "      quantity: #{item.quantity}"
    puts "      amount: #{item.amount.to_f}"
  end

  puts "    => Sender"
  puts "      name: #{payment.sender.name}"
  puts "      email: #{payment.sender.email}"
  puts "      phone: (#{payment.sender.phone.area_code}) #{payment.sender.phone.number}"
  puts "      document: #{payment.sender.document}: #{payment.sender.document}"

  puts "    => Shipping"
  puts "      street: #{payment.shipping.address.street}, #{payment.shipping.address.number}"
  puts "      complement: #{payment.shipping.address.complement}"
  puts "      postal code: #{payment.shipping.address.postal_code}"
  puts "      district: #{payment.shipping.address.district}"
  puts "      city: #{payment.shipping.address.city}"
  puts "      state: #{payment.shipping.address.state}"
  puts "      country: #{payment.shipping.address.country}"
  puts "      type: #{payment.shipping.type_name}"
  puts "      cost: #{payment.shipping.cost}"
end
