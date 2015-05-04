require_relative "boot"

installments = PagSeguro::Installment.find("100.00")

if installments.errors.any?
  puts "=> ERRORS"
  puts installments.errors.join("\n")
  puts installments.inspect
else
  puts "=> INSTALLMENTS"
  puts
  installments.each do |installment|
    puts installment.inspect
  end
end

# credentials = PagSeguro::ApplicationCredentials.new("app123", 'token')
visa_installments = PagSeguro::Installment.find("100.00", { card_brand: "visa")
# visa_installments = PagSeguro::Installment.find("100.00", { card_brand: "visa",
#   credentials: credentials })

puts
if installments.errors.any?
  puts "=> ERRORS"
  puts installments.errors.join("\n")
  puts installments.inspect
else
  puts "=> VISA INSTALLMENTS"
  puts
  visa_installments.each do |installment|
    puts installment.inspect
  end
end
