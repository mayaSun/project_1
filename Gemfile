source 'https://rubygems.org'
ruby '2.1.5'

gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'sidekiq'
gem 'unicorn'
gem 'paratrooper'
gem 'carrierwave'
gem 'mini_magick'
gem 'fog'
gem 'stripe'
gem 'figaro'
gem 'draper', '~> 1.3'
gem 'font-awesome-rails'
gem 'carmen'
gem 'carmen-rails'
gem 'turbolinks'


group :development do
  gem 'thin'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails'
end

group :test do
  gem 'shoulda-matchers', require: false
  gem 'database_cleaner', '1.2.0'
  gem 'fabrication'
  gem 'faker'
  gem 'capybara'
  gem 'capybara-email'
  gem 'rack_session_access'
  gem 'launchy'
  gem 'vcr'
  gem 'webmock'
  gem 'selenium-webdriver'
end

group :production do
  gem 'rails_12factor'
  gem "sentry-raven", :git => "https://github.com/getsentry/raven-ruby.git"
end

# for secure password
gem 'bcrypt-ruby', '3.1.2'