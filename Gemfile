source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.4.4'

gem 'rest-client'

gem 'httparty'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.2.0'

gem 'turbolinks', '~> 5' 

gem 'wdm', '>= 0.1.0'

# gem 'rails-i18n', '~> 5.1', '>= 5.1.3'

# Use SCSS for stylesheets
gem 'sassc-rails'
#
# # Use Compass for improve SASS features
gem 'compass-rails'
# # Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
#
# # Use jquery as the JavaScript library
gem 'jquery-rails'
# # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development
# # Use postgress as the database for Active Record
gem 'pg', '~> 1.2.3'

gem 'recaptcha', '~> 5.7'

gem 'devise'

gem 'ransack'

gem 'devise-i18n'

#
gem 'simple_form'
#
gem 'carrierwave'

gem 'friendly_id'
#
gem 'mini_magick'
#
gem 'will_paginate'
#
gem 'ckeditor'

gem 'newrelic_rpm'

gem 'cocoon'
#
gem 'inherited_resources'
#
gem 'slim'
#
gem 'nav_lynx'

gem 'stringify_date', '0.0.5'

gem 'plupload-rails'
#
gem 'jquery-inputmask-rails'

gem 'execjs'

gem 'responders'

gem 'tzinfo-data' 

gem 'mimemagic', github: 'mimemagicrb/mimemagic', ref: '3543363026121ee28d98dfce4cb6366980c055ee'

gem 'bootsnap', require: false 

# após bundle executar o comando: rails generate sidekiq:worker <Nome do Job>
# no application.rb colocar -> config.active_job.queue_adapter = :sidekiq
# no initializer sidekiq colocar as configurações do servidor redis
gem 'sidekiq'


group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'dedent'
  gem 'bullet'
  gem 'rspec-rails', '~> 5.0'
end 

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
end
#
gem 'bootstrap-sass'
gem 'momentjs-rails'
gem 'bootstrap3-datetimepicker-rails'
gem 'font-awesome-sass', '~> 5.6.1'



gem "simplecov", "~> 0.18.5", :group => :test, :require => false

gem "simplecov_json_formatter", "~> 0.1.4", :group => :test, :require => false
