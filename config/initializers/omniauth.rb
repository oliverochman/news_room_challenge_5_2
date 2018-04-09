Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook,
  Rails.application.credentials.facebook[:facebook_key],
  Rails.application.credentials.facebook[:facebook_secret],
  scope: 'email,public_profile'
end
