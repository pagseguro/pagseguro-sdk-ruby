module PagSeguro
  class Authorization
    class Collection
      extend Forwardable

      attr_writer :authorizations

      def_delegators :@authorizations, :each, :empty?, :any?

      def initialize(options = {})
        @errors = options[:errors] if options[:errors]
        @authorizations = instantiate_authorizations(options[:authorizations])
      end

      def errors
        @errors ||= Errors.new
      end

      private
      def instantiate_authorizations(authorizations)
        return [] unless authorizations
        authorizations.map do |authorization|
          Authorization.new(authorization)
        end
      end
    end
  end
end
