module PagSeguro
  class Authorization
    class RequestSerializer
      attr_reader :authorization

      def initialize(authorization)
        @authorization = authorization
      end

      def to_params
        params[:credentials] = authorization.credentials if authorization.respond_to? :credentials
        params[:initialDate] = authorization.initial_date if authorization.respond_to? :initial_date
        params[:finalDate]   = authorization.final_date if authorization.respond_to? :final_date

        params
      end

      private
      def params
        @params ||= {}
      end
    end
  end
end
