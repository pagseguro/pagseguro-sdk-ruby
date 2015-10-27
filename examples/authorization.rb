require_relative "boot"

# credentials have app_id and app_key infos
# permissions defaults to all permissions
# notification_url is a required param
# redirect_url is a required param

options = {
  permissions: [:searches, :notifications],
  notification_url: 'foo.com.br',
  redirect_url: 'bar.com.br'
}

authorization_request = PagSeguro::AuthorizationRequest.new(options)
if authorization_request.create
  print "Use this link to confirm authorizations: "
  puts authorization_request.url
else
  puts authorization_request.errors.join("\n")
end
