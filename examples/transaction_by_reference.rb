require_relative 'boot'

transaction = PagSeguro::Transaction.find_by_reference("REF1234")

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

