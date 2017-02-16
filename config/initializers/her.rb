Her::API.setup url: Rails.application.secrets.api_url do |c|
  # Request
  c.use TokenAuthentication
  c.use Faraday::Request::Multipart
  c.use Faraday::Request::UrlEncoded
  if Rails.env.development?
    c.response :logger, ::Logger.new(STDOUT), bodies: true
  end
  # Response
  c.use Her::Middleware::DefaultParseJSON

  # Adapter
  c.use Faraday::Adapter::NetHttp
end
