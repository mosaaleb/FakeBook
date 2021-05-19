# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.1'

# Use ActiveModel has_secure_password
# Use ActiveStorage variant
# Use Capistrano for deployment
# gem 'bcrypt', '~> 3.1.7'
# gem 'capistrano-rails', group: :development
# gem 'mini_magick', '~> 4.8'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'bootstrap', '~> 4.3.1'
gem 'coffee-rails', '~> 4.2'
gem 'devise', '~> 4.7'
gem 'font-awesome-rails'
gem 'hirb'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'omniauth-facebook'
gem 'omniauth-rails_csrf_protection'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.3'
gem 'rails', '~> 5.2.3'
gem 'sass-rails', '~> 5.0' # Use Uglifier as compressor for JavaScript assets
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry-byebug'
  gem 'rspec-rails'
end

group :development do
  gem 'guard-livereload', '~> 2.5', require: false
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'pry-rails'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'launchy'
  gem 'rails-controller-testing'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-html-matchers'
  gem 'selenium-webdriver'
  gem 'shoulda'
  gem 'shoulda-matchers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
