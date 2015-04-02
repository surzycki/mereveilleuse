$ -> 
  sendInvite = (to, message, callback) ->
    options = method: 'apprequests'
    
    if to
      options.to = to
    if message
      options.message = message
    
    FB.ui options, (response) ->
      if callback
        callback response
   
  onInvite = (e) ->
    e.preventDefault()
    location = $(e.currentTarget).data('redirect')
    
    sendInvite null, 'Les recommandations des mamans vous aident à protéger votre santé et celles de vos enfants', (response) ->
      if location && response.request
        window.location = location
      
      


  $(document).on 'click', '.x-invite', onInvite

 