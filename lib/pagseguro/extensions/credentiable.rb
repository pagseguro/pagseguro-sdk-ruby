module PagSeguro
  module Extensions
    module Credentiable
      include Extensions::EnsureType

      # Get the credential object value
      attr_reader :credentials

      # Set a credential object
      def credentials=(credentials)
        @credentials = ensure_type(Credentials, credentials)
      end
    end
  end
end
