require_relative "boot"

# Installment
#
# Required AccountCredentials
#
#   You need to give:
#     - amount
#     - brand_card
#     - account credentials (EMAIL, TOKEN)
#
#   You can pass this parameters to PagSeguro::Installment#find

credentials = PagSeguro::AccountCredentials.new('EMAIL', 'TOKEN')

options = {
  credentials: credentials # Unnecessary if you set in application config
}

installments = PagSeguro::Installment.find("100.00", nil, options)

if installments.errors.any?
  puts installments.errors.join("\n")
else
  puts "=> INSTALLMENTS"
  puts
  installments.each do |installment|
    puts installment.inspect
  end

  visa_installments = PagSeguro::Installment.find("100.00", :visa, options)

  puts
  puts "=> VISA INSTALLMENTS"
  puts
  visa_installments.each do |installment|
    puts installment.inspect
  end
end

