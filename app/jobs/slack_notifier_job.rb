class SlackNotifierJob < ActiveJob::Base
  queue_as :default

  def perform(message)
    notifier = Slack::Notifier.new AppFacebook.config.slack_webhook_url, 
      channel: AppFacebook.config.slack_channel,
      username: 'mereveilleuse'
    
    notifier.ping message, icon_url: AppFacebook.config.slack_icon_url
  
  rescue Exception => e
    TrackError.new e
  end
end