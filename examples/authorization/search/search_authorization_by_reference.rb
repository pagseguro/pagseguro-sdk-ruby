require_relative "../../boot"

# Search Authorization by Reference
#
#   You need to give:
#     - reference
#     - application credentials (APP_ID, APP_KEY)
#
#   You can pass these parameters to PagSeguro::Authorization#find_by

credentials = PagSeguro::ApplicationCredentials.new("APP_ID", "APP_KEY")

options = {
  reference: 'REF4321',
  credentials: credentials
}

collection = PagSeguro::Authorization.find_by(options)

if collection.errors.any?
  puts collection.errors.join("\n")
else
  collection.each do |authorization|
    puts "# #{authorization.code}"
    authorization.permissions.each do |permission|
      puts "Permission: "
      puts permission.code
      puts permission.status
    end
  end
end
