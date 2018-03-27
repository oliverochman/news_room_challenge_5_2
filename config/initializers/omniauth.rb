Rails.application.config.middleware.use OmniAuth::Builder do
  api_key: Rails.application.credentials.facebook[:facebook_key]
  api_secret: Rails.application.credentials.facebook[:facebook_secret]
end
