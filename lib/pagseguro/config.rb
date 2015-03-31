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

    # The application id
    attr_accessor :app_id

    # A token related to the application that is making the requests
    attr_accessor :app_key

    # The PagSeguro environment.
    # +production+ or +sandbox+.
    # Defaults to +production+.
    attr_accessor :environment

    # The encoding that will be used.
    # Defaults to +UTF-8+.
    attr_accessor :encoding

    def initialize
      @environment = :production
      @encoding = "UTF-8"
    end
  end
end
