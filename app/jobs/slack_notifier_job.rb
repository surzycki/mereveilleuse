class SlackNotifierJob < ActiveJob::Base
  queue_as :default

  def perform(message)
    notifier = Slack::Notifier.new ENV['SLACK_WEB_HOOK_URL'], 
      channel: ENV['SLACK_CHANNEL'],
      username: 'mereveilleuse'
    
    notifier.ping message, icon_url: ENV['SLACK_ICON']
  
  rescue Exception => e
    TrackError.new e
  end
end