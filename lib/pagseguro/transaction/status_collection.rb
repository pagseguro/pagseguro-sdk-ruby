module PagSeguro
  class Transaction
    class StatusCollection
      extend Forwardable

      def_delegators :@statuses, :each, :empty?, :any?

      def statuses=(objects)
        @statuses = objects
      end

      def errors
        @errors ||= Errors.new
      end

      # PagSeguro::TransactionStatus instances.
      attr_reader :statuses
    end
  end
end
