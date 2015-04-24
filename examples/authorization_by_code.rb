require_relative 'boot'

# credentials = PagSeguro::ApplicationCredentials.new("app452", "1D473")
credentials = PagSeguro::ApplicationCredentials.new("app45", "1D473")

options = {
  credentials: credentials
}

authorization = PagSeguro::Authorization.find_by_code('D9EED', options)

if authorization.errors.any?
  puts authorization.errors.join("\n")
else
  authorization.permissions.each do |permission|
    puts "Permission: "
    puts "  code: #{permission.code}"
    puts "  status: #{permission.status}"
  end
end
