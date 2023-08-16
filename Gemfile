source 'https://rubygems.org'
ruby '3.0.4'
gem 'rails', '~> 7.0', '>= 7.0.5'
gem 'sass-rails', '>= 6'
#gem 'turbolinks'
gem 'jbuilder'
gem 'cancancan'
gem 'devise'
gem 'devise_invitable'
gem 'devise-security' 
gem 'devise-i18n'
gem 'figaro'
gem "pg", "~> 1.1"
gem 'rolify'
gem 'simple_form'
gem "kt-paperclip", "~> 6.4", ">= 6.4.1"
gem 'kaminari'
gem 'rexml'

gem 'enumerize'
gem 'acts-as-taggable-on'
gem "crummy"
gem 'will_paginate'
gem 'fastercsv'
gem 'stringex'
gem 'humanizer'
gem 'rails_email_validator'
gem 'rscribd'
gem 'rubyzip'
gem 'analytics-ruby', '~> 2.0.0', :require => 'segment/analytics'
gem 'dynamic_form'
gem 'caxlsx'
gem "caxlsx_rails"
gem 'clamby'
gem 'aws-sdk-rails'
gem "aws-sdk-s3", require: false
gem 'impressionist'
gem 'sanitize'
gem 'negative_captcha'
gem "recaptcha", require: "recaptcha/rails"
gem 'puma', '~> 5.0'
gem 'ckeditor'

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

group :assets do
  #gem "chardinjs-rails"
  gem 'momentjs-rails'
  gem 'datetimepicker-rails', git: 'https://github.com/zpaulovics/datetimepicker-rails.git', branch: 'master', submodules: true
end
group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'powder'
  gem 'rails_layout'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
  gem 'listen'
  gem 'foreman'
end
group :development, :test do
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'faker'
end
gem 'dotenv-rails', groups: [:development, :test]
group :production do
  # gem 'cloudflare-rails'
end
group :test do
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'email_spec'
end
