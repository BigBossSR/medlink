source 'https://rubygems.org'

ruby '2.1.0'

gem 'rails', '4.1.0.rc1'

gem 'jquery-rails'
gem 'haml-rails'
gem 'twilio-ruby'
gem 'jquery-placeholder-rails'

gem 'devise'
gem 'cancan'

gem 'sucker_punch'

gem 'kaminari'

gem 'nested_form'

# 2.12.0 is borked - https://github.com/sstephenson/sprockets/issues/537
gem 'sprockets', '2.11.0'
gem 'sass-rails'
gem 'coffee-rails'
gem 'haml'
gem 'uglifier'

gem 'exceptiontrap'

group :development do
  gem 'sqlite3'
  gem 'pry'
  gem 'letter_opener'
  gem 'simplecov'
  gem 'coveralls', require: false
end

group :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'rake'
  gem 'factory_girl_rails'
  gem 'email_spec'
  gem 'sms-spec'
  gem 'database_cleaner'
  gem 'zonebie'
end

group :production do
  gem 'passenger'
  gem 'pg'
  gem 'rails_12factor' # For asset compilation
end
