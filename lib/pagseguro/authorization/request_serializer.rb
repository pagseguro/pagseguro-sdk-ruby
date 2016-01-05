module PagSeguro
  class Authorization
    class RequestSerializer
      attr_reader :authorization

      def initialize(options)
        @options = options
      end

      def to_params
        params[:credentials] = @options[:credentials] if @options[:credentials]
        params[:reference]   = @options[:reference] if @options[:reference]
        params[:initialDate] = @options[:initial_date].xmlschema if @options[:initial_date]
        params[:finalDate]   = @options[:final_date].xmlschema if @options[:final_date]
        params
      end

      private
      def params
        @params ||= {}
      end
    end
  end
end
