$ ->
  
  onLearnMore = (e) ->
    e.preventDefault()
    console.log 'learning more'
    $.scrollTo($('#learn-more-section'), 300)
    

  $(document).on 'click', '#learn-more', onLearnMore