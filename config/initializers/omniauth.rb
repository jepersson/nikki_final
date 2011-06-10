Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, 'COSTUMER_KEY', 'COSTUMER_SECRET'
end
