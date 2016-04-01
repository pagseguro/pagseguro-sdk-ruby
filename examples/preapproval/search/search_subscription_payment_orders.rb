require_relative '../../boot'

code = 'CODE'
status = :status # Are availables: [ :scheduled, :processing, :not_processed, :suspended, :paid, :not_paid ]
email = 'EMAIL'
token = 'TOKEN'

credentials = PagSeguro::AccountCredentials.new(email, token)

options = { credentials: credentials }

report = PagSeguro::SubscriptionSearchPaymentOrders.new(code, status, options)

if report.valid?

  while report.next_page?
    report.next_page!

    puts report.payment_orders.inspect
  end

else
  puts "Errors:"
  puts report.errors.join("\n")
end
