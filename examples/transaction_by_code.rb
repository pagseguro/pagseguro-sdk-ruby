require_relative "boot"

transaction = PagSeguro::Transaction.find_by_code("739D69-79C052C05280-55542D9FBB33-4AB2D0")
puts transaction
