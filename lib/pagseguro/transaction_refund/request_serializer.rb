module PagSeguro
  class TransactionRefund
    class RequestSerializer
      # The refund that will be serialized.
      attr_reader :refund

      def initialize(refund)
        @refund = refund
      end

      def to_params
        {}.tap do |data|
          data[:transactionCode] = refund.transaction_code
          data[:refundValue] = to_amount(refund.value)
        end.delete_if { |_, value| value.nil? }
      end

      private
      def to_amount(amount)
        "%.2f" % BigDecimal(amount.to_s).round(2).to_s("F") if amount
      end
    end
  end
end
