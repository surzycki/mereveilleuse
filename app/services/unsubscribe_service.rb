class UnsubscribeService
  include Wisper::Publisher

  def unsubscribe_search(search)
    # send remider email to come back to site in 48hrs if this search was active
    if search.active?
      RecommendationMailer.reciprocate(search.user).deliver_later(wait: 48.hours) 
    end

    search.canceled!
    
    publish :unsubscribe_search_success, search
  rescue => e
    publish :unsubscribe_search_fail, I18n.t('unsubscribe.search.not_found')
  end

  def unsubscribe_account(user)
    user.searches.each(&:canceled!)
    user.unsubscribed!

    UnsubscribeMailer.account(user).deliver_later

    publish :unsubscribe_account_success, user
  rescue => e  
    publish :unsubscribe_account_fail, I18n.t('errors.general')
  end
end