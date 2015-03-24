module PagSeguro
  class Credentials
    # The application id
    attr_accessor :app_id

    # The application key
    attr_accessor :app_key

    def initialize(app_id, app_key)
      @app_id, @app_key = app_id, app_key
    end

    def authorize
      Request.post(path, api_version, credentials)
    end

    private
    def path
      'authorizations/request'
    end

    def api_version
      'v2'
    end

    def credentials
      "appId=#{app_id}&appKey=#{app_key}"
    end
  end
end
