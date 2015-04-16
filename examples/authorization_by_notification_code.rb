require_relative 'boot'

options = {
  credentials: PagSeguro::Credentials.new("app452", "1D473")
}

authorization = PagSeguro::Authorization.find_by_notification_code('ad#213', options)

authorization.permissions.each do |permission|
  puts "Permission: "
  puts permission.code
  puts permission.status
end
