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
    img_src: %w('self' https://maps.googleapis.com https://csi.gstatic.com https://*.s3.amazonaws.com data: https://maps.gstatic.com https://q.stripe.com/),
    script_src: %w('self' https://maps.googleapis.com https://js.stripe.com/v3/ https://api.stripe.com/v1/ https://cdn.layer.com/sdk/ 'unsafe-eval' 'unsafe-inline'),
    upgrade_insecure_requests: ENV['APP_PROTOCOL'] == true,
    style_src: %w('unsafe-inline' 'self' https://fonts.googleapis.com/css),
    child_src: %w('self' https://js.stripe.com/v3/),
    connect_src: %w('self' https: wss:)
  )
end
