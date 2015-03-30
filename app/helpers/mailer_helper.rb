module MailerHelper
  def static_map_for(location, options = {})
    
    params = {
      center:    [location.latitude, location.longitude].join(','),
      zoom:      15,
      size:      '300x300',
      markers:   [location.latitude, location.longitude].join(','),
      sensor:    true
    }.merge(options)
 
    query_string =  params.map{|k,v| "#{k}=#{v}"}.join("&")
    image_tag "http://maps.googleapis.com/maps/api/staticmap?#{query_string}", alt: location.address, class: 'center'
  end

  def rating_image(rating)
    if rating > 3
      "#{rating}-rating-checked.png"
    else
      "#{rating}-rating-hover.png"
    end
  end

  def canvas_recommendation_path
    "#{ENV['FACEBOOK_CANVAS']}?app_data=#{new_recommendation_path}"
  end

  def canvas_unsubscribe_search_path(search)
    "#{ENV['FACEBOOK_CANVAS']}?app_data=#{unsubscribe_search_path(search.md5_hash)}"
  end

  def canvas_unsubscribe_account_path(user)
    "#{ENV['FACEBOOK_CANVAS']}?app_data=#{unsubscribe_account_path(user.facebook_id)}"
  end
end