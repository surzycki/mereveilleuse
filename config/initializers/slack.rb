class Application < Rails::Application
  config.slack_webhook_url = 'https://hooks.slack.com/services/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'
  config.slack_icon_url    = 'https://canvas.mereveilleuse.com/images/mereveilleuse.jpg'
  config.slack_channel     = '#mereveilleuse'
end