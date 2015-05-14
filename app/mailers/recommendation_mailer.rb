class RecommendationMailer < ApplicationMailer
  layout 'mailer_with_header'
  
  def results(search, recommendations, is_expanded_search = false)
    @recommendation     = recommendations.first
    
    @search             = search
    @user               = search.user
    @recommender        = @recommendation.recommender
  
    @is_expanded_search = is_expanded_search

    mail(
      to: @user.email, 
      subject: subject_for_results(search)
    )
  end

  def reciprocate(user)
    @user = user

    mail(
      to: @user.email, 
      subject: subject_for_reciprocate
    ) 
  end

  private
  def subject_for_results(search)
    "❤ #{I18n.t('email.recommendation.subject', profession: search.profession_name.pluralize, address: search.address )}"
  end

  def subject_for_reciprocate
    "❤ Vous avez trouvé votre spécialiste"
  end
end
