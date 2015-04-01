class ApplicationMailer < ActionMailer::Base
  helper MailerHelper
  helper FormattingHelper 

  default from: '"Mèreveilleuse" <team@mereveilleuse.com>'
  
  layout 'mailer_with_header'
end
