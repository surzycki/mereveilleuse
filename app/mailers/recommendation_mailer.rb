class RecommendationMailer < ApplicationMailer
  def results(search, recommendations)
    # don't send if no recommendations
    return if recommendations.empty?
    
    @search             = search
    @user               = search.user
    @recommendations    = recommendations

    mail(
      to: @user.email, 
      subject: subject_for_results(search)
    )
  end

  private
  def subject_for_results(search)
    I18n.t('email.recommendation.subject', profession: search.profession_name.pluralize, address: search.address )
  end
end
