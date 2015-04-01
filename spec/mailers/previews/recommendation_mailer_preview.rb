# Preview all emails at http://localhost:3000/rails/mailers/recommendation_mailer
class RecommendationMailerPreview < ActionMailer::Preview
  def results
    search = Search.all.sample
    recommendations = [ Recommendation.all.sample ]
    
    Premailer::Rails.config.merge!(skip_premailer: true)

    RecommendationMailer.results search, recommendations
  end
end
