module PagSeguro
  class TransactionCancellation
    class RequestSerializer
      # The transaction_cancellation that will be serialized.
      attr_reader :transaction_cancellation

      def initialize(transaction_cancellation)
        @transaction_cancellation = transaction_cancellation
      end

      def to_params
        {}.tap do |data|
          data[:transactionCode] = transaction_cancellation.transaction_code
        end.delete_if { |_, value| value.nil? }
      end
    end
  end
end
