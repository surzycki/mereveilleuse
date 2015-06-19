class SlackNotifierListener
  def login(account, redirect_path)
    return if account.nil?

    send_notification "*#{account.fullname}* logged in from #{account.platform}"
  end

  def signup(account)
    return if account.nil?

    send_notification "*#{account.fullname}* accepted permissions from #{account.platform}"
  end

  def authentication_fail(errors)
    return if errors.nil?

    send_notification('authentication error')
  end

  def recommendation_created(recommendation)
    return if recommendation.nil?

    practitioner = recommendation.practitioner
    
    message = "*#{practitioner.fullname}* has been recommended"

    send_notification message
  end

  def recommendation_create_fail(errors)
    return if errors.nil?

    send_notification(errors.full_messages.join(', '))
  end

  def user_created(user, registration_type)
    return if user.nil?

    message = "*#{user.fullname}* has signed up"

    send_notification message
  end

  def user_create_fail(errors)
    return if errors.nil?

    message = "user create failed #{errors.full_messages.join(', ')}"

    send_notification(message)
  end

  def search_success(results, search)
    return if results.nil? || search.nil?

    username = Maybe(search.user).fullname._
    message  = "*#{username}* #{search}"
   
    send_notification message
  end

  def search_no_results(search)
    return if search.nil?

    username = Maybe(search.user).fullname._
    message  = "*#{username}* trying expanded #{search}"
   
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