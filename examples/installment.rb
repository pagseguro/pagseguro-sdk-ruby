require_relative "boot"

credentials = PagSeguro.application_credentials
credentials.authorization_code = "BF0C85F19BEB4011AC4D99C88C6E0638"

installments = PagSeguro::Installment.find("100.00", {credentials: credentials})

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

visa_installments = PagSeguro::Installment.find("100.00", { card_brand: "visa", credentials: credentials })

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
