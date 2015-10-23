module PagSeguro
  class Installment
    class Collection
      extend Forwardable

      def_delegators :@installments, :each, :empty?, :any?

      def installments=(objects)
        @installments = instantiate_installments(objects)
      end

      def errors
        @errors ||= Errors.new
      end

      private
      def instantiate_installments(installments)
        return [] unless installments
        installments.map do |installment|
          Installment.new(installment)
        end
      end
    end
  end
end
