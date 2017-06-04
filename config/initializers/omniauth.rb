Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :google_oauth2, Setting['global.auth']['google']['client_id'], Setting['global.auth']['google']['client_secret'],
           {
             name: 'google'
           }
  provider :facebook, Setting['global.auth']['facebook']['app_id'], Setting['global.auth']['facebook']['secret_key'],
           {
             secure_image_url: true
           }
end