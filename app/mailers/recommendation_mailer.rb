class RecommendationMailer < ApplicationMailer
  layout 'mailer_without_header'

  def results(search, recommendations)
    # don't send if no recommendations
    return if recommendations.empty?
    
    @recommendation     = recommendations.first
    
    @search             = search
    @user               = search.user
    @recommender        = @recommendation.recommender
  
    mail(
      to: @user.email, 
      subject: subject_for_results(search),
      skip_premailer: true
    )
  end

  private
  def subject_for_results(search)
    "❤ #{I18n.t('email.recommendation.subject', profession: search.profession_name.pluralize, address: search.address )}"
  end
end
