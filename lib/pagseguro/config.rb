module PagSeguro
  # Holds the configuration of the user
  class Config
    # Primary e-mail associated with this account.
    attr_accessor :email

    # The e-mail that will be displayed when sender is redirected
    # to PagSeguro.
    attr_accessor :receiver_email

    # The API token associated with this account.
    attr_accessor :token
  end
end
