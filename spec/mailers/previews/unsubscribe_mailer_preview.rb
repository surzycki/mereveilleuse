# Preview all emails at http://localhost:3000/rails/mailers/unsubscribe_mailer
class UnsubscribeMailerPreview < ActionMailer::Preview
  def account
    user = User.first
    UnsubscribeMailer.account(user)
  end
end
