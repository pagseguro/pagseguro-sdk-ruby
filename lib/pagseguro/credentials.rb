module PagSeguro
  class Credentials
    # The application id
    attr_accessor :app_id

    # The application key
    attr_accessor :app_key

    def initialize(app_id, app_key)
      @app_id, @app_key = app_id, app_key
    end
  end
end
