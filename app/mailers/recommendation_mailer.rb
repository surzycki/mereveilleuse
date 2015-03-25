class RecommendationMailer < ApplicationMailer
  def results(search, recommendations)
    # don't send if no recommendations
    return if recommendations.empty?
    
    @search             = search
    @user               = search.user
    @search_profession  = search.professions.first
    @recommendations    = recommendations

    mail(
      to: @user.email, 
      subject: I18n.t('email.recommendation.subject', profession: @search_profession.name.pluralize, address: search.address )
    )
  end
end
