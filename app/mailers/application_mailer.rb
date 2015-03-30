class ApplicationMailer < ActionMailer::Base
  include Roadie::Rails::Automatic
  
  helper MailerHelper
  helper FormattingHelper 

  default from: 'team@mereveilleuse.com'
  
  # see https://github.com/Mange/roadie-rails#known-issues
  self.asset_host = nil
  
  layout 'mailer_with_header'

  private
  def roadie_options
    super unless Rails.env.test?
  end
end
