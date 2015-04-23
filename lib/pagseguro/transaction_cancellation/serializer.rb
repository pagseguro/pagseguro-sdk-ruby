module PagSeguro
  class TransactionCancellation
    class Serializer
      # The refund that will be serialized.
      attr_reader :refund

      def initialize(refund)
        @refund = refund
      end

      def to_params
        params[:transactionCode] = refund.transaction_code

        params.delete_if {|key, value| value.nil? }

        params
      end

      private
      def params
        @params ||= {}
      end
    end
  end
end
