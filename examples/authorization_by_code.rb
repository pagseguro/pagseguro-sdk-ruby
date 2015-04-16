require_relative 'boot'

options = {
  credentials: PagSeguro::Credentials.new("app452", "1D473")
}

authorization = PagSeguro::Authorization.find_by_code('92FDQ3', options)

authorization.permissions.each do |permission|
  puts "Permission: "
  puts permission.code
  puts permission.status
end
