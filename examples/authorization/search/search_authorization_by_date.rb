require_relative "../../boot"

# Search Authorization by Code
#
#   You need to give:
#     - authorization code
#     - application credentials (APP_ID, APP_KEY) OR account credentials (EMAIL, TOKEN)
#
#   You can pass these parameters to PagSeguro::Authorization#find_by
#
# PS: For more details take a look at the class PagSeguro::Authorization#find_by

# credentials = PagSeguro::AccountCredentials.new("EMAIL", "TOKEN")
credentials = PagSeguro::ApplicationCredentials.new('APP_ID', 'APP_KEY')

options = {
  initial_date: Time.new(2015, 10, 1, 0, 0),
  final_date: Time.now,
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
