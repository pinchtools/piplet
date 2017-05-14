Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?

  provider :google_oauth2, Setting['global.oauth.google.client_id'], Setting['global.oauth.google.client_secret'],
           {
             :name => 'google'
           }
end