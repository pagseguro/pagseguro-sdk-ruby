module PagSeguro
  class TransactionCancellation
    class RequestSerializer
      # The transaction_cancellation that will be serialized.
      attr_reader :transaction_cancellation

      def initialize(transaction_cancellation)
        @transaction_cancellation = transaction_cancellation
      end

      def to_params
        params[:transactionCode] = transaction_cancellation.transaction_code

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
