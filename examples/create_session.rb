require_relative "boot"

session = PagSeguro::Session.create

puts session.data.inspect
