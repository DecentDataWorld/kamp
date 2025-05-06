require 'logger'
impressionist_dir = Gem::Specification.find_by_name('impressionist').gem_dir
require File.join(impressionist_dir, '/app/controllers/impressionist_controller.rb')
require_relative 'boot'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Mesp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0
    config.assets.css_compressor = nil

    config.active_record.yaml_column_permitted_classes = [
      Symbol,
      Date,
      Time,
      BigDecimal,
      Hash,
      Array,
      String,
      Integer,
      Float,
      ActiveSupport::HashWithIndifferentAccess,
      ActionDispatch::Http::UploadedFile,
      Tempfile,
      File,
      URI
    ]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
