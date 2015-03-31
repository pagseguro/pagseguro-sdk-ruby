module PagSeguro
  class Credentials
    # The application id
    attr_accessor :app_id

    # The application key
    attr_accessor :app_key

    attr_accessor :notification_url

    attr_accessor :redirect_url

    def initialize(app_id, app_key, notification_url, redirect_url)
      @app_id = app_id
      @app_key = app_key
      @notification_url = notification_url
      @redirect_url = redirect_url
    end
  end
end
