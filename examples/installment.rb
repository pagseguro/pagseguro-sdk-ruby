require_relative "boot"

installments = PagSeguro::Installment.find("100.00")

puts "=> INSTALLMENTS"
puts
installments.each do |installment|
  puts installment.inspect
end

# credentials = PagSeguro::ApplicationCredentials.new("app123", 'token')
visa_installments = PagSeguro::Installment.find("100.00", { card_brand: "visa" })
# visa_installments = PagSeguro::Installment.find("100.00", { card_brand: "visa",
#   credentials: credentials })

puts
puts "=> VISA INSTALLMENTS"
puts
visa_installments.each do |installment|
  puts installment.inspect
end
