module PagSeguro
  class TransactionCancellation
    class Serializer
      # The refund that will be serialized.
      attr_reader :refund

      def initialize(refund)
        @refund = refund
      end

      def to_params
        {}.tap do |data|
          data[:transactionCode] = refund.transaction_code
        end
      end
    end
  end
end
