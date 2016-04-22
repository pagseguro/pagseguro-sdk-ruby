require_relative '../../boot'

# Search Subscriptions by date interval
#
# You need to give AccountCredentials (EMAIL, TOKEN) and some date interval
#
# P.S: See the boot file example for more details.

email = 'user@example.com'
token = 'TOKEN'

credentials = PagSeguro::AccountCredentials.new(email, token)
options = {
  credentials: credentials,
  starts_at: Time.new(2016,3,15),
  ends_at: Time.new(2016,3,24),
  per_page: 10
}
report = PagSeguro::Subscription.search_by_date_interval(options)

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
  end

  puts "- End page"
else
  puts "Errors:"
  puts report.errors.join("\n")
end
