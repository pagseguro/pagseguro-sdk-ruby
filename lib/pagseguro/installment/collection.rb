module PagSeguro
  class Installment
    class Collection
      extend Forwardable

      def_delegators :@installments, :each, :empty?, :any?, :join, :include?

      def initialize(installments)
        @installments = installments.map { |installment| Installment.new(installment) }
      end
    end
  end
end
