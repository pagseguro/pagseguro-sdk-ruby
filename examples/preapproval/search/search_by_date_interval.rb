require_relative '../../boot'

# Search Subscriptions by date interval
#
# You need to give AccountCredentials (EMAIL, TOKEN) and some date interval
#
# P.S: See the boot file example for more details.

credentials = PagSeguro::AccountCredentials.new('user@example.com', 'TOKEN')
options = {
  credentials: credentials,
  starts_at: Time.new(2016,3,15),
  ends_at: Time.new(2016,3,24),
  per_page: 10
}
report = PagSeguro::Subscription.search_by_date_interval(options)

if report.errors.empty?
  while report.next_page?
    report.next_page!

    puts report.subscriptions.inspect

    puts "results per page: #{report.results}"
    puts "total pages: #{report.total_pages}"
    puts "page: #{report.page}"

  end
else
  puts "Errors:"
  puts report.errors.join("\n")
end
