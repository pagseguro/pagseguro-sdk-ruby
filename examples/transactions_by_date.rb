require_relative "boot"
require "active_support/all"

report = PagSeguro::Transaction.find_by_date(starts_at: 29.days.ago, per_page: 1)

while report.next_page?
  report.next_page!
  puts "== Fetching page #{report.page}"
  puts report.created_at
  puts

  report.transactions.each do |transaction|
    puts transaction.created_at
    puts transaction.code
    puts transaction.cancellation_source
    puts transaction.payment_method.type
    puts transaction.gross_amount
    puts transaction.updated_at
    puts
    puts
  end
end
