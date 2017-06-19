class TokenAuthentication < Faraday::Middleware
  def call(env)
    if RequestStore.store[:auth_token]
      env[:request_headers]["Authorization"] = "Bearer #{RequestStore.store[:auth_token]}"
    end
    env[:request_headers]["Accept"] = "application/json;application/vnd.sagn.v2"
    @app.call(env)
  end
end
