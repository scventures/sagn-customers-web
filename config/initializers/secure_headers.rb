SecureHeaders::Configuration.default do |config|
  config.cookies = {
    secure: ENV['APP_PROTOCOL'] == true, # mark all cookies as "Secure"
    httponly: true, # mark all cookies as "HttpOnly"
    samesite: {
      lax: true # mark all cookies as SameSite=lax
    }
  }
  config.csp.merge!(
    default_src: %W(#{ENV['APP_PROTOCOL']}: 'self'),
    img_src: %w('self' https://maps.googleapis.com https://csi.gstatic.com https://*.s3.amazonaws.com data: https://maps.gstatic.com),
    script_src: %w('self' https://maps.googleapis.com 'unsafe-eval'),
    script_src: %w('self' https://js.stripe.com/v2/ 'unsafe-eval'),
    upgrade_insecure_requests: ENV['APP_PROTOCOL'] == true,
    style_src: %w('unsafe-inline' 'self' https://fonts.googleapis.com/css)
  )
end
