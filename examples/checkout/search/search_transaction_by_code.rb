require_relative "../../boot"

# Search Transaction by Code
#
#   You need to give:
#     - transaction code
#     - account credentials (EMAIL, TOKEN) OR application credentials (APP_ID, APP_KEY)
#
#   You can pass these parameters to PagSeguro::Transaction#find_by_code

# credentials = PagSeguro::ApplicationCredentials.new('APP_ID', 'APP_KEY')
credentials = PagSeguro::AccountCredentials.new('EMAIL', 'TOKEN')

options = { credentials: credentials } # Unnecessary if you set in application config

transaction = PagSeguro::Transaction.find_by_code("TRANSACTION_CODE", options)

if transaction.errors.any?
  puts transaction.errors.join("\n")
else
  puts "=> Transaction"
  puts "  code: #{transaction.code}"
  puts "  type: #{transaction.type_id}"
  puts "  status: #{transaction.status.status}"
  puts "  cancellation source: #{transaction.cancellation_source}"
  puts "  escrow end date: #{transaction.escrow_end_date}"
  puts "  payment method type: #{transaction.payment_method.type}"
  puts "  gross amount: #{transaction.gross_amount.to_f}"
  puts "  discount amount: #{transaction.discount_amount.to_f}"
  puts "  operational fee amount: #{transaction.creditor_fees.operational_fee_amount.to_f}"
  puts "  installment fee amount: #{transaction.creditor_fees.installment_fee_amount.to_f}"
  puts "  intermediation rate amount: #{transaction.creditor_fees.intermediation_rate_amount.to_f}"
  puts "  intermediation fee amount: #{transaction.creditor_fees.intermediation_fee_amount.to_f}"
  puts "  commission fee amount: #{transaction.creditor_fees.commission_fee_amount.to_f}"
  puts "  commission fee amount: #{transaction.creditor_fees.commission_fee_amount.to_f}"
  puts "  efrete: #{transaction.creditor_fees.efrete.to_f}"
  puts "  net amount: #{transaction.net_amount.to_f}"
  puts "  extra amount: #{transaction.extra_amount.to_f}"

  puts "    => Payments"
  puts "      installment count: #{transaction.installments}"
  transaction.payment_releases.each do |release|
    puts "    current installment: #{release.installment}"
    puts "    total amount: #{release.total_amount.to_f}"
    puts "    release amount: #{release.release_amount.to_f}"
    puts "    status: #{release.status}"
    puts "    release date: #{release.release_date}"
  end

  puts "    => Items"
  puts "      items count: #{transaction.items.size}"
  transaction.items.each do |item|
    puts "      item id: #{item.id}"
    puts "      description: #{item.description}"
    puts "      quantity: #{item.quantity}"
    puts "      amount: #{item.amount.to_f}"
    puts "      weight: #{item.weight}g"
  end

  puts "    => Sender"
  puts "      name: #{transaction.sender.name}"
  puts "      email: #{transaction.sender.email}"
  puts "      phone: (#{transaction.sender.phone.area_code}) #{transaction.sender.phone.number}"
  puts "      document: #{transaction.sender.document.type}: #{transaction.sender.document.value}"

  puts "    => Shipping"
  puts "      street: #{transaction.shipping.address.street}, #{transaction.shipping.address.number}"
  puts "      complement: #{transaction.shipping.address.complement}"
  puts "      postal code: #{transaction.shipping.address.postal_code}"
  puts "      district: #{transaction.shipping.address.district}"
  puts "      city: #{transaction.shipping.address.city}"
  puts "      state: #{transaction.shipping.address.state}"
  puts "      country: #{transaction.shipping.address.country}"
  puts "      type: #{transaction.shipping.type_name}"
  puts "      cost: #{transaction.shipping.cost}"
end
