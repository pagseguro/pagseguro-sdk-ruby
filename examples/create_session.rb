require_relative "boot"

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
