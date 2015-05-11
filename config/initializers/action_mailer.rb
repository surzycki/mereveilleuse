# We do this so that the capybara_email gem works.  If we use the premailer in
# the test environment, capybara_email can't retrieve the email to open it
# here we skip the premailer in the test environment
class ActionMailer::Base
  if Rails.env.test?
    default skip_premailer: true
  end
end