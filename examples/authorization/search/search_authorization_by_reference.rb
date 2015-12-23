require_relative "../../boot"

# Search Authorization by Reference
#
#   You need to give:
#     - reference
#     - application credentials (APP_ID, APP_KEY)
#
#   You can pass this parameters to PagSeguro::Authorization#find_by_reference

credentials = PagSeguro::ApplicationCredentials.new("APP_ID", "APP_KEY")

options = { credentials: credentials, reference: 'REF1234' }

authorization = PagSeguro::Authorization.find_by_code('AUTHORIZATION_CODE', options)

if authorization.errors.any?
  puts authorization.errors.join("\n")
else
  puts authorization.inspect
end
