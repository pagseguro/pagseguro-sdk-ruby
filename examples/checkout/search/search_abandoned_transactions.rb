require "active_support/all"
require_relative "../../boot"

# Search Abandoned Transactions
#
#   The acount credentials (EMAIL, TOKEN) are required
#
#   You can pass the credentials parameters to PagSeguro::Transaction#find_abandoned

options = {
  credentials: PagSeguro::AccountCredentials.new('EMAIL', 'TOKEN'),
  starts_at: Time.new(2016, 2, 10, 14, 0),
  ends_at: Time.new(2016, 2, 11, 14, 0),
  per_page: 50
  # You can pass more arguments by params, look (/lib/pagseguro/transaction.rb)
}

report = PagSeguro::Transaction.find_abandoned(options)

# OR through the application settings like the boot file example (/examples/boot.rb)
#
# report = PagSeguro::Transaction.find_abandoned

while report.next_page?
  report.next_page!
  puts "=> Fetching page #{report.page}"

  abort "=> Errors: #{report.errors.join("\n")}" unless report.valid?

  puts "=> Report was created at: #{report.created_at}"
  puts

  report.transactions.each do |transaction|
    puts "=> Abandoned transaction"
    puts "   created at: #{transaction.created_at}"
    puts "   code: #{transaction.code}"
    puts "   type_id: #{transaction.type_id}"
    puts "   gross amount: #{transaction.gross_amount.to_f}"
    puts
  end
end
