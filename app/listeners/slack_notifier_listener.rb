class SlackNotifierListener
  def login(account, redirect_path)
    return if account.nil?

    send_notification "*#{account.fullname}* logged in"
  end

  def signup(account)
    return if account.nil?

    send_notification "*#{account.fullname}* is signing up"
  end

  def authentication_fail(errors)
    return if errors.nil?

    send_notification('authentication error')
  end

  def recommendation_created(recommendation)
    return if recommendation.nil?

    recommender  = recommendation.recommender
    practitioner = recommendation.practitioner
    
    message = if recommender.recommendations.count <= 1
      "*#{recommender.fullname} signed up* by recommending *#{practitioner.fullname}*"
    else
      "*#{recommender.fullname}* recommended *#{practitioner.fullname}*"
    end

    send_notification message
  end

  def recommendation_create_fail(errors)
    return if errors.nil?

    send_notification(errors.full_messages.join(', '))
  end

  def search_success(results, search)
    return if results.nil? || search.nil?

    username = Maybe(search.user).fullname._
    
    message = if results.is_a? ActiveJob::Base
      "*#{username}* queued #{search}"
    else
      "*#{username}* was sent #{search}" unless results.count.zero?
    end

    send_notification message
  end

  def search_fail(errors) 
    return if errors.nil? 

    send_notification(errors.full_messages.join(', '))
  end

  private 
  def send_notification(message)
    return if message.nil?
    
    SlackNotifierJob.perform_later message
  end
end