require_relative '../boot'

# Create a Subscription Discount.
#
# You need to set your AccountCredentials (EMAIL, TOKEN) in the application
# config.
#
# P.S: See the boot file example for more details.

email = 'EMAIL'
token = 'TOKEN'

discount = PagSeguro::SubscriptionDiscount.new(
  # The types of discount are DISCOUNT_PERCENT and DISCOUNT_AMOUNT.
  type: 'DISCOUNT_AMOUNT',
  value: 5.0,
  code: '00951371D7D707B7745AFF9D4D4AE763',
)

# Edit the lines above.

discount.credentials = PagSeguro::AccountCredentials.new(email, token)
discount.create

if discount.errors.any?
  puts '=> ERRORS'
  puts discount.errors.join('\n')
else
  print '=> Subscription Discount correct added.'
end
