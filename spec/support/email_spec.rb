RSpec.configure do |config|
  config.include EmailSpec::Helpers,                type: :mailer
  config.include EmailSpec::Matchers,               type: :mailer
  config.include ActionView::Helpers::NumberHelper, type: :mailer
  config.include ApplicationHelper,                 type: :mailer
  config.include MailerHelper,                      type: :mailer
end