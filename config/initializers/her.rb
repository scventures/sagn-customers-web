user_agent = "SAGN Customers Web app Revision-#{`git rev-parse --short HEAD`.strip} #{'(development-env)' if Rails.env.development?}"

Her::API.setup url: ENV['API_URL'], send_only_modified_attributes: true, headers: { user_agent: user_agent } do |c|
  # Request
  c.use TokenAuthentication
  c.use Faraday::Request::Multipart
  c.use Faraday::Request::UrlEncoded
  if Rails.env.development?
    c.response :logger, ::Logger.new(STDOUT), bodies: true
  end
  # Response
  c.use Her::Middleware::ResponseParserJSON

  # Adapter
  c.use Faraday::Adapter::NetHttp
end

Her::Model.send :include, Her::Model::Extension
Hashie.logger = Logger.new(nil)
