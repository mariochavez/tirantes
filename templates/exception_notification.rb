if Rails.env.staging? || Rails.env.production?
  Whatever::Application.config.middleware.use ExceptionNotification::Rack,
    :email => {
      :email_prefix => ENV['EXCEPTION_NOTIFICATION_PREFIX'] || "[Exception] ",
      :sender_address => ENV['EXCEPTION_NOTIFICATION_SENDER'] || %{"notifier" <notifier@example.com>},
      :exception_recipients => ENV['EXCEPTION_NOTIFICATION_RECIPIENTS'] || %w{exceptions@example.com}
    }
end
