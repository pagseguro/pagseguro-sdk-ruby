require_relative '../../boot'

# Search Subscriptions by days interval
# PS: Since it has receipt some notification in the interval
#
# You need to give AccountCredentials (EMAIL, TOKEN) and some days interval
#
# P.S: See the boot file example for more details.

email = 'user@example.com'
token = 'TOKEN'
interval = 30

credentials = PagSeguro::AccountCredentials.new('user@example.com', 'TOKEN')
options = {
  credentials: credentials,
  interval: interval
}
report = PagSeguro::Subscription.search_by_days_interval(options)

if report.valid?
  puts "====== Report ======"

  while report.next_page?
    report.next_page!

    puts "=> Page #{report.page}/#{report.total_pages}"
    report.subscriptions.each_with_index do |subscription, index|
      puts "Subscription #{index+1}/#{report.results}:"
      puts "  code: #{subscription.code}"
      puts "  name: #{subscription.name}"
      puts "  date: #{subscription.date}"
      puts "  tracker: #{subscription.tracker}"
      puts "  status: #{subscription.status}"
      puts "  last event date: #{subscription.last_event_date}"
      puts "  charge: #{subscription.charge}"
      puts "  reference: #{subscription.reference}"
    end

    puts "- End page "
  end
  puts " - End report"
else
  puts "Errors:"
  puts report.errors.join("\n")
end
