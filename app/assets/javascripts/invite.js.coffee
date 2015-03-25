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
   
  onInvite = ->
    sendInvite null, 'Some text that goes here to get people to do stuff', (response) ->
      console.log 'sendInvite', response


  $(document).on 'click', '#invite', onInvite

 