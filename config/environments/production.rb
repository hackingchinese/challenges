Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.assets.js_compressor = :uglifier
  config.assets.compile = false
  config.assets.digest = true
  config.assets.version = '1.0'
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.action_mailer.default_url_options = { :host =>  'challenges.hackingchinese.com'}
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.active_record.dump_schema_after_migration = false
  config.action_mailer.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = YAML.load_file('config/email.yml')

  config.lograge.enabled = true
  config.lograge.custom_options = lambda do |event|
    exceptions = %w(controller action format id)
    {
      params: event.payload[:params].except(*exceptions),
      ip: event.payload[:ip]
    }
  end
  config.middleware.use ExceptionNotification::Rack,
    :email => {
    :email_prefix => "[Challenge] ",
    :sender_address => %{"challenge" <challenges@hackingchinese.com>},
    :exception_recipients => %w{info@stefanwienert.de}
  }
end
