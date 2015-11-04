require_relative "boot"

# Create Session
#
# You need to set your AccountCredentials (EMAIL, TOKEN) in the application config
#
# P.S: See the boot file example for more details.

session = PagSeguro::Session.create

if session.errors.any?
  puts "=> ERRORS"
  puts session.errors.join("\n")
  puts session.inspect
else
  puts "=> SESSION"
  puts session.id
  puts session.inspect
end
