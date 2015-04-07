module PagSeguro
  module Extensions
    module Credentiable
      include Extensions::EnsureType

      attr_reader :credentials

      def credentials=(credentials)
        @credentials = ensure_type(Credentials, credentials)
      end
    end
  end
end
