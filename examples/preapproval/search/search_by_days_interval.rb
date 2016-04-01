require_relative '../../boot'

# Search Subscriptions by days interval
# PS: Since it has receipt some notification in the interval
#
# You need to give AccountCredentials (EMAIL, TOKEN) and some days interval
#
# P.S: See the boot file example for more details.

credentials = PagSeguro::AccountCredentials.new('user@example.com', 'TOKEN')
options = {
  credentials: credentials,
  interval: 30
}
report = PagSeguro::Subscription.search_by_days_interval(options)

if report.errors.empty?

  while report.next_page?
    report.next_page!

    puts report.subscriptions.inspect
  end

else
  puts "Errors:"
  puts report.errors.join("\n")
end
