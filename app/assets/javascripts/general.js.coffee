$ ->
  $('#slider').slippry
    transition: 'vertical'
    captions: 'custom'
    captionsEl: '.browser-mockup-captions'
    pause: 6000


  onLearnMore = (e) ->
    e.preventDefault()
    
    if window.is_canvas()
      FB.Canvas.scrollTo(0,$('#learn-more-section').position().top + 42)
    else
      $.scrollTo($('#learn-more-section'), 300)


  $(document).on 'click', '#learn-more', onLearnMore