require_relative "boot"

session = PagSeguro::Session.create

if session.errors.any?
  puts session.errors.join("\n")
else
  puts "=> SESSION"
  puts session.id
  puts sessions.inspect
end
