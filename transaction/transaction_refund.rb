require_relative "boot"

# Refund
#
# You need:
#   - set your AccountCredentials (EMAIL, TOKEN) in the application config
#   - set transaction code
#   - set value (optional)
#
# P.S: See the boot file example for more details

refund = PagSeguro::TransactionRefund.new
refund.transaction_code = "D5D5BE444148407891E497B421975599"

# Partial refund
# refund.value = 400.00

response = refund.register

if response.errors.any?
  puts response.errors.join("\n")
else
  puts "=> REFUND RESPONSE"
  puts response.result
end
