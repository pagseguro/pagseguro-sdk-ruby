module PagSeguro
  class Installment
    class RequestSerializer
      # The data that will be serialized.
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def to_params
        params[:amount] = data[:amount]
        params[:cardBrand] = data[:card_brand] if data[:card_brand]

        params
      end

      private
      def params
        @params ||= {}
      end
    end
  end
end
