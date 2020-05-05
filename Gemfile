source 'https://rubygems.org'
ruby '2.3.0'
gem 'rails', '4.2.11.1'
gem 'rake', '< 11.0'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'bootstrap-sass'
gem 'cancancan', '~> 1.7'
gem 'devise'
gem 'devise_invitable'
gem 'devise_security_extension'
gem 'devise-i18n'
gem 'figaro'
gem 'pg', '~> 0.18'
gem 'rolify'
gem 'simple_form'
gem "paperclip", ">= 5.0"
gem 'ed25519'
gem 'bcrypt_pbkdf'
gem 'rbnacl-libsodium'
gem 'rbnacl', '~> 5.0.0'
gem 'kaminari'

gem 'enumerize'
gem 'acts-as-taggable-on'
gem "crummy", "~> 1.8.0"
gem 'will_paginate', '~> 3.0'
gem 'datagrid'
gem 'leaflet-rails'
gem 'jquery-datatables-rails', '~> 3.2.0'
gem 'fastercsv'
gem 'sunspot_rails'
gem 'sunspot_solr'
gem 'progress_bar'
gem 'social-share-button'
gem 'stringex'
gem 'humanizer'
gem 'rails_email_validator'
gem 'tagmanager-rails'
gem 'rscribd'
gem 'rubyzip', '< 1.0.0'
gem 'rails_admin', '< 0.7.0'
gem 'analytics-ruby', '~> 2.0.0', :require => 'segment/analytics'
gem 'dynamic_form'
gem 'axlsx', '~> 2.0'
gem "axlsx_rails"
gem 'clamby'
gem 'sitemap', :git => 'https://github.com/viseztrance/rails-sitemap.git'
gem 'aws-sdk', '>= 2.0'
gem "bugsnag"
gem 'impressionist'
gem 'gibbon', '3.2.0'
gem 'sanitize'
gem 'ckeditor'
gem 'negative_captcha'
gem "recaptcha", require: "recaptcha/rails"
gem 'rails_12factor'
gem 'newrelic_rpm'

gem 'puma'

group :assets do
  gem "chardinjs-rails"
  gem 'momentjs-rails'
  gem 'datetimepicker-rails', :git => 'https://github.com/zpaulovics/datetimepicker-rails.git',  :branch => 'master', :submodules => true
end
group :development do
  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'powder'
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'quiet_assets'
  gem 'rails_layout'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
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
  gem 'shoulda-matchers', '~> 4.0.1'
  gem 'capybara', '3.14.0'
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
end
