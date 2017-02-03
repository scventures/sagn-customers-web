class TokenAuthentication < Faraday::Middleware
  def call(env)
    env[:request_headers]["Authorization"] = "Bearer #{RequestStore.store[:auth_token]}"
    @app.call(env)
  end
end
