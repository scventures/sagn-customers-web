class User
  attr_accessor :email, :password
  require 'rest-client'
  require 'net/http'
  require 'uri'
  include ActiveModel::Validations #required because some before_validations are defined in devise
  extend ActiveModel::Callbacks #required to define callbacks
  extend Devise::Models

  define_model_callbacks :validation #required by Devise
  devise :remote_authenticatable
  devise :registerable
  
  def self.authenticate!(email, password)
    begin
      uri = URI.parse("https://stapp.sendaguy.com/api/customers/auth_token")
      request = Net::HTTP::Post.new(uri)
      request.content_type = "application/x-www-form-urlencoded"
      request["Accept"] = "application/json"
      request.set_form_data("auth[email]" => email, "auth[password]" => password)
      req_options = {use_ssl: uri.scheme == "https"}
      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
      if response and response.code == "201"
        return JSON.parse(response.body)["jwt"]
      end
    rescue => exec
    end
  end
end
