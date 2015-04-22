require_relative 'boot'

# credentials = PagSeguro::ApplicationCredentials.new("app452", "1D473")
credentials = PagSeguro::AccountCredentials.new("app452", "1D473")

options = {
  credentials: credentials
}

authorization = PagSeguro::Authorization.find_by_notification_code('ad#213', options)

if authorization.errors.any?
  puts authorization.errors.join("\n")
else
  authorization.permissions.each do |permission|
    puts "Permission: "
    puts permission.code
    puts permission.status
  end
end
