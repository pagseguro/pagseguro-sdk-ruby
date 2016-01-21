require_relative "../../boot"

# Search Transaction by Reference
#
#   You need to give:
#     - reference code
#     - account credentials (EMAIL, TOKEN)
#
#   You can pass these parameters to PagSeguro::Transaction#find_by_reference

credentials = PagSeguro::AccountCredentials.new('EMAIL', 'TOKEN')

options = { credentials: credentials } # Unnecessary if you set in application config

transaction = PagSeguro::Transaction.find_by_reference("REFERENCE_CODE", options)

while transaction.next_page?
  transaction.next_page!
  puts "== Page #{transaction.page}"
  abort "=> Errors: #{transaction.errors.join("\n")}" unless transaction.valid?
  puts "Report created on #{transaction.created_at}"
  puts

  transaction.transactions.each do |transaction|
    puts "=> Transaction"
    puts "   created_at: #{transaction.created_at}"
    puts "   code: #{transaction.code}"
    puts "   cancellation_source: #{transaction.cancellation_source}"
    puts "   payment method: #{transaction.payment_method.type}"
    puts "   gross amount: #{transaction.gross_amount.to_f}"
    puts "   updated at: #{transaction.updated_at}"
    puts "   status: #{transaction.status.status}"
    puts
  end
end

