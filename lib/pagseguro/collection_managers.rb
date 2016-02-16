module PagSeguro
  module CollectionManagers
    module MacroMethods
      def collection_type(klass)
        define_method 'collection_type' do
          self.class.classify(klass, PagSeguro)
        end
      end

      def collection_manager(klass)
        define_method 'collection_manager' do
          self.class.classify(klass, CollectionManagers)
        end
      end

      def camelize(param)
        param.to_s.split('_').map(&:capitalize).join
      end

      def to_class(klass, super_klass)
        super_klass.const_get( camelize(klass) )
      end

      def classify(klass, super_klass)
        to_class(klass, super_klass)
      end
    end
  end
end
