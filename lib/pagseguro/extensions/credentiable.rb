module PagSeguro
  module Extensions
    module Credentiable
      # Get the credential object value
      attr_reader :credentials

      # Set a credential object
      def credentials=(credentials)
        if credentials.kind_of?(ApplicationCredentials) || credentials.kind_of?(AccountCredentials)
          @credentials = credentials
        else
         raise 'Invalid credentials object'
       end
      end
    end
  end
end
