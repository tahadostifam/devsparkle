require_relative "boot"

require "rails/all"

require './lib/github_user_api'
require './lib/uri_escape'
require './lib/grecaptcha'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Devsparkle
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.

    config.load_defaults 6.1

    config.serve_static_assets = true
    
    config.autoload_paths << Rails.root.join('lib')

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Asia/Tehran"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
