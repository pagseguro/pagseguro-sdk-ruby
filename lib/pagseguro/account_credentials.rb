module PagSeguro
  class AccountCredentials
    # The user email
    attr_accessor :email

    # The token related to the user
    attr_accessor :token

    def initialize(email, token)
      @email = email
      @token = token
    end
  end
end
