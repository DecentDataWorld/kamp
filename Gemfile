source 'https://rubygems.org'
ruby '3.0.4'
gem 'rails', '~> 6.0.3', '>= 6.0.3.4'
gem 'sass-rails', '>= 6'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.7'
gem 'bootstrap-sass'
gem 'cancancan'
gem 'devise'
gem 'devise_invitable'
#gem 'devise_security_extension'
gem 'devise-security' #replacing above
gem 'devise-i18n'
gem 'figaro'
gem 'pg', '>= 0.18', '< 2.0'
gem 'rolify'
gem 'simple_form'
gem "paperclip", ">= 5.0"
gem 'ed25519'
gem 'bcrypt_pbkdf'
#gem 'rbnacl-libsodium'
#gem 'rbnacl'
gem 'kaminari'
#added blow
gem 'rexml'

gem 'enumerize'
gem 'acts-as-taggable-on'
gem "crummy"
gem 'will_paginate'
gem 'datagrid'
gem 'jquery-datatables-rails'
gem 'fastercsv'
gem 'progress_bar'
gem 'social-share-button'
gem 'stringex'
gem 'humanizer'
gem 'rails_email_validator'
#gem 'tagmanager-rails'
gem 'rscribd'
gem 'rubyzip'
#gem 'rails_admin', '< 0.7.0'
gem 'analytics-ruby', '~> 2.0.0', :require => 'segment/analytics'
gem 'dynamic_form'
gem 'caxlsx'
gem "caxlsx_rails"
gem 'clamby'
gem 'aws-sdk-rails'
gem "aws-sdk-s3", require: false
#gem "bugsnag"
#gem 'impressionist'
gem 'gibbon'
gem 'sanitize'
gem 'ckeditor'
gem 'negative_captcha'
gem "recaptcha", require: "recaptcha/rails"
gem 'puma', '~> 4.1'

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
