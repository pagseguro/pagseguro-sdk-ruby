module PagSeguro
  class ApplicationCredentials
    # The application id
    attr_accessor :app_id

    # The token related to the application
    attr_accessor :app_key

    # The application authorization code
    attr_accessor :authorization_code

    def initialize(app_id, app_key, authorization_code = nil)
      @app_id = app_id
      @app_key = app_key
      @authorization_code = authorization_code
    end
  end
end
