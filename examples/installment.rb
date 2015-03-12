require_relative "boot"

installments = PagSeguro::Installment.find("100.00")

puts "=> INSTALLMENTS"
puts
installments.each do |installment|
  puts installment.inspect
end


visa_installments = PagSeguro::Installment.find("100.00", "visa")

puts
puts "=> VISA INSTALLMENTS"
puts
visa_installments.each do |installment|
  puts installment.inspect
end
