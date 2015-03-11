require_relative "boot"

session = PagSeguro::Session.create

puts session.inspect
