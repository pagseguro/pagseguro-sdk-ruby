require_relative "../../boot"
require "active_support/all"

# Search Transactions by Date
#
#   You need to give:
#     - reference code
#     - account credentials (EMAIL, TOKEN)
#
#   You can pass these parameters to PagSeguro::Transaction#find_by_date

credentials = PagSeguro::AccountCredentials.new('EMAIL', 'TOKEN')

options = {
  starts_at: 29.days.ago,
  per_page: 1,
  credentials: credentials # Unnecessary if you set in application config
}

report = PagSeguro::Transaction.find_by_date(options)

while report.next_page?
  report.next_page!
  puts "== Page #{report.page}"
  abort "=> Errors: #{report.errors.join("\n")}" unless report.valid?
  puts "Report created on #{report.created_at}"
  puts

  report.transactions.each do |transaction|
    puts "=> Transaction"
    puts "   created_at: #{transaction.created_at}"
    puts "   code: #{transaction.code}"
    puts "   cancellation_source: #{transaction.cancellation_source}"
    puts "   type: #{transaction.type_id}"
    puts "   status: #{transaction.status.status}"
    puts "   payment method: #{transaction.payment_method.type}"
    puts "   gross amount: #{transaction.gross_amount.to_f}"
    puts "   discount amount: #{transaction.discount_amount.to_f}"
    puts "   net amount: #{transaction.net_amount.to_f}"
    puts "   extra amount: #{transaction.extra_amount.to_f}"
    puts "   updated at: #{transaction.updated_at}"
    puts "   status: #{transaction.status.status}"
    puts
  end
end
