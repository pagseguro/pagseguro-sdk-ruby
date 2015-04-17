module PagSeguro
  class Refund
    class Serializer
      # The refund that will be serialized.
      attr_reader :refund

      def initialize(refund)
        @refund = refund
      end

      def to_params
        params[:transactionCode] = refund.transaction_code
        params[:refundValue] = to_amount(refund.value)

        params.delete_if {|key, value| value.nil? }

        params
      end

      private
      def params
        @params ||= {}
      end

      def to_amount(amount)
        "%.2f" % BigDecimal(amount.to_s).round(2).to_s("F") if amount
      end
    end
  end
end
