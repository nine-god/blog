require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Blog1
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.time_zone = 'Beijing'
    config.active_record.default_timezone = :local

    config.i18n.default_locale = 'zh-CN'


    config.active_job.queue_adapter = :sidekiq
    # config.assets.paths << Rails.root.join("lib")

    config.autoload_paths += [
      Rails.root.join('lib')
    ]
    config.eager_load_paths += [
      Rails.root.join('lib/blog'),
      Rails.root.join('lib/oauth')
    ]
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      :address        => "smtp.qq.com", # default: localhost
      :port           => '587',   # default: 25
      :domain         => "qq.com",
      :user_name      => ENV["EMAIL_USER_NAME"],
      :password       => ENV["EMAIL_KEY_BASE"],
      :authentication => :plain                 # :plain, :login or :cram_md5
    }
  end
end
