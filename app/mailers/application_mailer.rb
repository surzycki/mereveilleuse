class ApplicationMailer < ActionMailer::Base
   include Roadie::Rails::Automatic
   
  default from: 'team@mereveilleuse.com'
  
  layout 'mailer'
end
