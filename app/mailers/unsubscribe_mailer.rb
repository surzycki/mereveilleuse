class UnsubscribeMailer < ApplicationMailer
  layout 'mailer_with_header'

  def account(user)
    @user = user

    mail(
      to: @user.email, 
      subject: subject_for_account
    )
  end

  private
  def subject_for_account
    "❤ Désinscription à la newsletter de MèreVeilleuse"
  end
end