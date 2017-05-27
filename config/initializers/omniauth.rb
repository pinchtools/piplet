Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :google_oauth2, Setting['global.auth']['google']['client_id'], Setting['global.auth']['google']['client_secret'],
           {
             :name => 'google'
           }
end