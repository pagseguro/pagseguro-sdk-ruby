module PagSeguro
  class Installment
    class Collection
      extend Forwardable

      def_delegators :@installments, :each, :empty?, :any?

      def initialize(options)
        @errors = options[:errors] if options[:errors]
        @installments = instantiate_installments(options[:installments])
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
