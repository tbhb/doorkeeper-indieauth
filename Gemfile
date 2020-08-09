# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

gem 'bootsnap'
gem 'rails', '~> 6.0'

gem 'activerecord-jdbcsqlite3-adapter', platform: :jruby
gem 'listen'
gem 'sqlite3', platform: %i[ruby mswin mingw x64_mingw]
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw]

group :development do
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
  gem 'danger', require: false
  gem 'web-console'
end

group :test do
  gem 'coveralls', require: false
  gem 'webmock', require: false
end

group :development, :test do
  gem 'byebug'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'rubocop-faker', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end
