module PagSeguro
  class Installment
    class RequestSerializer
      # The data that will be serialized.
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def to_params
        params
      end

      private
      def params
        @params ||= {}
      end
    end
  end
end
