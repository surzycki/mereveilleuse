Sidekiq.configure_server do |config|
  config.redis = { url: "#{ENV['REDIS_URL']}/0", namespace: "sidekiq_mereveilleuse_#{Rails.env}" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "#{ENV['REDIS_URL']}/0", namespace: "sidekiq_mereveilleuse_#{Rails.env}" }
end