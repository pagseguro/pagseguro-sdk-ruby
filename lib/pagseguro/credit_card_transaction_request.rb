module PagSeguro
  class CreditCardTransactionRequest < TransactionRequest
    # Set credit card token.
    # Required for credit card payment method.
    attr_accessor :credit_card_token

    # Get installment info.
    # Required for credit card payment method.
    attr_reader :installment

    # Get credit card holder info.
    # Required for credit card payment method.
    attr_reader :holder

    # Get billing address info.
    # Required for credit card payment method.
    attr_reader :billing_address

    # Set the installment
    def installment=(installment)
      @installment = ensure_type(TransactionInstallment, installment)
    end

    # Set the credit card holder.
    # Required if payment method is credit card
    def holder=(holder)
      @holder = ensure_type(Holder, holder)
    end

    # Set the billing address.
    def billing_address=(address)
      @billing_address = ensure_type(Address, address)
    end
  end
end
