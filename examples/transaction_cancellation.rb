require_relative "boot"

cancellation = PagSeguro::TransactionCancellation.new
cancellation.transaction_code = "AFB8FCF29496401681257C1ECE3A98FF"

response = cancellation.register

if response.errors.any?
  puts response.errors.join("\n")
else
  puts "=> CANCELLATION RESPONSE"
  puts response.result
end
