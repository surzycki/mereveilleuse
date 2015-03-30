# Preview all emails at http://localhost:3000/rails/mailers/help_mailer
class HelpMailerPreview < ActionMailer::Preview
  def customer_service
    email   = 'test_user@test.com'
    subject = 'this is a test subject'
    message = 'this is a test message'
    HelpMailer.customer_service(email, subject, message)
  end
end
