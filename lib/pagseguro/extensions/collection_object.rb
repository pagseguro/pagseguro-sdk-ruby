module PagSeguro
  module Extensions
    module CollectionObject
      extend Forwardable
      include Enumerable
      include EnsureType

      def_delegators :@store, :size, :clear, :empty?, :any?, :each, :include?

      attr_accessor :store

      def initialize
        @store = []
      end

      def collection_type
        PagSeguro.const_get(class_name_singularized)
      end

      # Adds a new object to the collection.
      def <<(param)
        object = ensure_type(collection_type, param)
        @store << object unless include?(object)
      end

      private

      def class_name_singularized
        class_name = self.class.to_s.split('::').last
        class_name[0...-1] if class_name.end_with? 's'
      end
    end
  end
end
