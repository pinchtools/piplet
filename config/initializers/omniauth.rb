Rails.application.config.middleware.use OmniAuth::Builder do
  begin
    provider :developer unless Rails.env.production?
    provider :google_oauth2, Setting['global.auth']['google']['client_id'], Setting['global.auth']['google']['client_secret'],
             {
               name: 'google'
             }
    provider :facebook, Setting['global.auth']['facebook']['app_id'], Setting['global.auth']['facebook']['secret_key'],
             {
               secure_image_url: true
             }
  rescue ActiveRecord::StatementInvalid
    # This will happen when migrating a new database
  rescue => e
    # Don't stop initialization if something goes wrong here
  end
end