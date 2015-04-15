class HelpMailer < ApplicationMailer
  layout false

  def customer_service(email, subject, message)
    @email        = email
    @subject      = subject
    @message      = message

    mail(
      to: 'contact@mereveilleuse.com', 
      subject: subject
    )
  end

  private
  def subject_for_results(search)
    I18n.t('email.recommendation.subject', profession: search.profession_name.pluralize, address: search.address )
  end
end
