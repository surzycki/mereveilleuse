class RecommendationMailer < ApplicationMailer
  def results(search, recommendations)
    # don't send if no recommendations
    return if recommendations.empty?
    
    @user               = search.user
    @search_profession  = search.professions.first
    @search_location    = search.location
    @recommendations    = recommendations

    mail(
      to: @user.email, 
      subject: I18n.t('email.recommendation.subject', profession: @search_profession.name.pluralize, postal_code: @search_location.postal_code )
    )
  end
end
