class SlackNotifierListener
  def login(account, redirect_path)
    send_notification "*#{account.fullname}* logged in"
  end

  def signup(account)
    send_notification "*#{account.fullname}* signed up"
  end

  def authentication_fail(errors)
  end

  def recommendation_created(recommendation)
    recommender  = recommendation.recommender
    practitioner = recommendation.practitioner
    
    send_notification "*#{recommender.fullname}* recommended #{practitioner.fullname}"
  end

  def recommendation_create_fail(errors)
  end

  def search_success(results)
  end

  def search_fail(errors)
  end

  private 
  def send_notifiaction(message)
    SlackNotifierJob.perform_later(message)
  end
end