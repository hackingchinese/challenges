source "https://rubygems.org"

## Basic
gem "rails", "~> 5.2.0"
gem "pg"
gem "pg_search"
gem "slim-rails"
gem "simple_form", '>= 4.0.0'
gem "scenic"
gem "active_params", '~> 1.0.0'
gem 'datagrid'

## User Auth
#
gem "devise"
gem "omniauth"
gem "omniauth-twitter"
gem "omniauth-facebook"
gem "cancancan", "~> 1.7"
gem "bootsnap", require: false

### Frontend
#
gem "sass-rails"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.0"
gem "jquery-rails"
gem "turbolinks", '~> 5.0.0.beta'
gem "bootstrap", "~> 4.1"
source "https://rails-assets.org" do
  gem "rails-assets-tether", ">= 1.1.0"
  gem "rails-assets-dragula"
end
gem "font-awesome-rails"
gem "highcharts-rails", "~> 3.0.0"
gem "select2-rails"
gem "autoprefixer-rails"

### Rails plugins
gem "kaminari"
gem "carrierwave"
gem "simple_captcha2", "~> 0.3", require: "simple_captcha"

### Utils
gem "mini_magick"
gem "quilt"
gem "rmagick" # dep of quilt
gem "redcarpet"
gem "whenever"
gem "stringex"
gem "typhoeus"
gem "headless"
gem "wkhtmltoimage-binary"
gem "meta-tags"
gem "sitemap_generator"

group :development do
  gem "rails_layout"
  gem "listen"
end

group :development, :test do
  gem "faker"
  gem "fabrication"
  gem "pry-rails"
  gem "rspec-rails", ">= 3.6.0"
  gem "puma"
  gem "vcr"
  gem "webmock"
  gem 'phantomjs-binaries', '~> 2.1'
end

group :test do
  gem "simplecov", require: false
  gem "capybara"
  gem 'chromedriver-helper'
  gem 'capybara-selenium'
  gem 'selenium-webdriver'
  gem "database_cleaner", "1.0.1"
  gem "email_spec"
  gem "timecop"
end

group :production do
  gem "lograge"
  gem "exception_notification"
end

gem "rack-attack", "~> 6.3"
gem "redis"
