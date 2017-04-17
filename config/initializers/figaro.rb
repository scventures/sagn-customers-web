Figaro.require_keys('API_URL', 'APP_HOST', 'APP_PROTOCOL') unless Rails.env.production?
APP_URL = "#{ENV['APP_PROTOCOL']}://#{ENV['APP_HOST']}"
