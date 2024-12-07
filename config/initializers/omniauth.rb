Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Rails.application.secrets.facebook_api_key, Rails.application.secrets.facebook_api_secret
end
