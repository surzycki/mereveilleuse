class SlackNotifierListener
  def login(account, redirect_path)
    send_notification "*#{account.fullname}* logged in"
  end

  def signup(account)
    send_notification "*#{account.fullname}* is signing up"
  end

  def authentication_fail(errors)
  end

  def recommendation_created(recommendation)
    recommender  = recommendation.recommender
    practitioner = recommendation.practitioner
    
    message = if recommender.recommendations.empty?
      "*#{recommender.fullname} signed up* by recommending *#{practitioner.fullname}*"
    else
      "*#{recommender.fullname}* recommended *#{practitioner.fullname}*"
    end

    send_notification message
  end

  def recommendation_create_fail(errors)
  end

  def search_success(results)
  end

  def search_fail(errors)
  end

  private 
  def send_notification(message)
    SlackNotifierJob.perform_later("#{Rails.env}: #{message}")
  end
end