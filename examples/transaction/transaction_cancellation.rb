require_relative "../boot"

cancellation = PagSeguro::TransactionCancellation.new
cancellation.transaction_code = "AFB8FCF29496401681257C1ECE3A98FF"

cancellation.register

if cancellation.errors.any?
  puts cancellation.errors.join("\n")
else
  puts "=> CANCELLATION RESPONSE"
  puts cancellation.result
end
