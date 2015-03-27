class ApplicationMailer < ActionMailer::Base
  include Roadie::Rails::Automatic
  
  helper MailerHelper
   
  default from: 'team@mereveilleuse.com'
  
  layout 'mailer'
end
