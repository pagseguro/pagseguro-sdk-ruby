module PagSeguro
  class Transaction
    class Collection
      extend Forwardable

      def_delegators :@transactions, :each, :empty?, :any?

      def transactions=(objects)
        @transactions = objects
      end

      def errors
        @errors ||= Errors.new
      end

      # PagSeguro::TransactionStatus instances.
      attr_reader :transactions
    end
  end
end
