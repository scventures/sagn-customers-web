class TokenAuthentication < Faraday::Middleware
  def call(env)
    if RequestStore.store[:auth_token]
      env[:request_headers]["Authorization"] = "Bearer #{RequestStore.store[:auth_token]}"
      env[:request_headers]["HTTP_USER_AGENT"] = "SAGN Customers Web app Revision-#{`git rev-parse --short HEAD`.strip} #{'(development-env)' if Rails.env.development?}"
    end
    env[:request_headers]["Accept"] = "application/json;application/vnd.sagn.v2"
    @app.call(env)
  end
end
