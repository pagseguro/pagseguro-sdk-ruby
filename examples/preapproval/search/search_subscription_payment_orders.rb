require_relative '../../boot'

code = 'CODE'
status = :processing # Availables: [ :scheduled, :processing, :not_processed, :suspended, :paid, :not_paid ]
email = 'EMAIL'
token = 'TOKEN'

credentials = PagSeguro::AccountCredentials.new(email, token)

options = { credentials: credentials }

report = PagSeguro::SubscriptionSearchPaymentOrders.new(code, status, options)

if report.valid?
  puts "====== Report ======"

  while report.next_page?
    report.next_page!

    puts "=> Page #{report.page}/#{report.total_pages}"
    report.payment_orders.each_with_index do |order, index|
      puts "Payment Order #{index}:"
      puts "  Code: #{order.code}"
      puts "  Status: #{order.status}"
      puts "  Amount: #{order.amount}"
      puts "  Gross amount: #{order.gross_amount}"
      puts "  Last event date: #{order.last_event_date}"
      puts "  Scheduling date: #{order.scheduling_date}"

      if order.discount
        puts "Discount:"
        puts "  Discount: #{order.discount.type}"
        puts "  Discount: #{order.discount.value}"
        puts "  Discount: #{order.discount.code}"
      end

      if order.transactions.any?
        order.transactions.each_with_index do |transaction, index|
          puts "Transaction #{index+1}/#{order.transactions.size}"
          puts "  Transaction code: #{transaction.code}"
          puts "  Transaction status: #{transaction.status}"
          puts "  Transaction date: #{transaction.date}"
        end
      end
    end
    puts "- End page"
    puts
  end

else
  puts "Errors:"
  puts report.errors.join("\n")
end
