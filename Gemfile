source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.15'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'bootstrap', '~> 4.0.0.alpha3'
gem 'font-awesome-rails'


# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# security
# gem 'rack-attack'
# gem 'rack-security'

gem 'redis'
gem 'redis-rails'

# background processing
gem 'sidekiq'
gem 'sidekiq-statistic'

gem 'active_model_serializers'

# Pagination
gem 'will_paginate'


# Use Puma as the app server
gem 'puma'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

#gem 'mail'

gem "rails-settings-cached"

gem 'active_link_to'

gem 'netaddr', '~> 1.5', '>= 1.5.1'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  gem 'rspec-rails', '~> 3.0'

  gem 'shoulda'

  gem 'mocha'

  gem 'factory_girl_rails', '~> 4.0'

  gem 'faker'

  gem 'mock_redis'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'rubocop'

  gem 'rails_best_practices'

  gem 'mailcatcher'

  gem 'better_errors'

  # Add a comment summarizing the current schema on models & specs
  gem 'annotate'

end


group :test do
  gem 'rspec-sidekiq'
end
