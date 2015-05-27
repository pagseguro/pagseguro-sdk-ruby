module PagSeguro
  class Authorization
    class RequestSerializer
      attr_reader :authorization

      def initialize(authorization)
        @authorization = authorization
      end

      def to_params
        params[:credentials] = authorization.credentials if authorization.credentials

        params
      end

      private
      def params
        @params ||= {}
      end
    end
  end
end
