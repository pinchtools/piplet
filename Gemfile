source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.15'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'webpacker', '~> 3.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'detect_timezone_rails'
gem 'http_accept_language'

gem 'bootstrap', '4.0.0.alpha5'
gem 'font-awesome-rails'

gem 'friendly_id', '~> 5.1.0'
gem 'ancestry'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# security
gem 'rack-attack'

gem 'redis'
gem 'redis-rails'
gem 'redis-namespace'

# background processing
gem 'sidekiq'
gem 'sidekiq-scheduler', '~> 2.0'
gem 'sidekiq-statistic'

gem 'responders', '~> 2.0'

gem 'active_model_serializers', '~> 0.10.0'
gem 'jwt'

# Pagination
gem 'will_paginate'

gem 'mini_magick'
gem 'carrierwave'
gem 'letter_avatar'

# Use Puma as the app server
gem 'puma'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

#gem 'mail'

gem 'rails-settings-cached', '~> 0.6.0'

gem 'active_link_to'

gem 'netaddr', '~> 1.5', '>= 1.5.1'

gem 'pry'

#oauth
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-facebook'
gem 'omniauth-twitter'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  gem 'rspec-rails', '~> 3.0'

  gem 'shoulda'

  gem 'mocha'

  gem 'factory_bot_rails', '~> 4.0'

  gem 'faker'

  gem 'mock_redis'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'rubocop'

  gem 'rails_best_practices'

  gem 'mailcatcher'

  gem 'better_errors'

  # Add a comment summarizing the current schema on models & specs
  gem 'annotate'

  gem 'guard-rspec', require: false

  gem 'marginalia' #attach comments to AR queries
end


group :test do
  gem 'rspec-sidekiq'
  gem 'rails-controller-testing'
  gem 'capybara'
end
