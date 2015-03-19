require_relative "boot"
require "active_support/all"

report = PagSeguro::Transaction.find_abandoned(
  starts_at: 30.days.ago,
  size: 1
)

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
