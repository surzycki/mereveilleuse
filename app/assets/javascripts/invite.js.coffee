$ -> 
  sendChallenge = (to, message, callback) ->
    options = method: 'apprequests'
    if to
      options.to = to
    if message
      options.message = message
    FB.ui options, (response) ->
      if callback
        callback response
      return
    return

  onChallenge = ->
    sendChallenge null, 'Some text that goes here to get people to do stuff', (response) ->
      console.log 'sendChallenge', response
      return
    return

  $(document).on 'click', '#tester', onChallenge