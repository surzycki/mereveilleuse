$ ->
  
  onLearnMore = (e) ->
    e.preventDefault()
    console.log 'learning more'
    FB.Canvas.scrollTo(0,$('#learn-more-section').position().top + 42)

  $(document).on 'click', '#learn-more', onLearnMore