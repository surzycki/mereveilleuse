$ ->
  # landing image slider
  $('#slider').slippry
    transition: 'vertical'
    captions: 'custom'
    captionsEl: '.browser-mockup-captions'
    pause: 6000


  onLearnMore = (e) ->
    e.preventDefault()
    PubSub.publish( 'mixpanel:sdk:track:event', 'acquisition:learn' )
 
    if window.is_canvas()
      FB.Canvas.scrollTo(0,$('#learn-more-section').position().top + 42)
    else
      $.scrollTo($('#learn-more-section'), 300)


  $(document).on 'click', '#x-learn-more', onLearnMore