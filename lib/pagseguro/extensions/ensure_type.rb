module PagSeguro
  module Extensions
    module EnsureType
      def ensure_type(klass, options = {})
        options.kind_of?(klass) ? options : klass.new(options)
      end
    end
  end
end
