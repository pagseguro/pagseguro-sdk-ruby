require_relative "boot"

installments = PagSeguro::Installment.find("100.00")

puts installments.inspect
