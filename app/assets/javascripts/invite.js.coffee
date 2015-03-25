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

  $(document).on 'click', '#invite', onChallenge

  #$('#commit').avgrund
  #  height: 200
  #  width: 640
  #  holderClass: 'custom'
  #  showClose: true
  #  showCloseText: 'Close'
  #  enableStackAnimation: true
  #  onBlurContainer: 'body'
  #  template: '<p>So implement your design and place content here! If you want to close modal, please hit "Esc", click somewhere on the screen or use special button.</p>' + '<div>' + '<a href="http://github.com/voronianski/jquery.avgrund.js" target="_blank" class="github">Avgrund on Github</a>' + '<a href="http://twitter.com/voronianski" target="_blank" class="twitter">Twitter</a>' + '<a href="http://dribbble.com/voronianski" target="_blank" class="dribble">Dribbble</a>' + '</div>'
