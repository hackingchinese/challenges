source 'https://rubygems.org'

## Basic
#
gem 'rails', '~> 4.2.0'
gem 'pg'
gem 'slim-rails'
gem 'simple_form', '~> 3.1'
gem 'inherited_resources'
gem 'responders'


## User Auth
#
gem 'devise'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'cancancan', '~> 1.7'

### Frontend
#
gem 'sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'bootstrap', '~> 4.0.0.alpha3'
source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
end
gem "font-awesome-rails"
gem "highcharts-rails", "~> 3.0.0"


### Utils
gem "carrierwave"
gem "mini_magick"
gem "quilt"
gem "rmagick"
gem "redcarpet"
gem "whenever"
gem "stringex"
gem "simple_captcha2", '~> 0.3', require: 'simple_captcha'
gem "autoprefixer-rails"
gem "kaminari"


group :development do
  gem 'quiet_assets'
  gem 'rails_layout'
end

group :development, :test do
  gem 'faker'
  gem 'fabrication'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'pry-doc'
  gem 'rspec-rails'
  gem 'thin'
end

group :test do
  gem 'simplecov', require: false
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
  gem 'timecop'
end

group :production do
  gem 'exception_notification'
end

