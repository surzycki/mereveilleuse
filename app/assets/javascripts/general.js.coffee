$ ->
  
  try 
    if window.self != window.top
      $('#test').append( "<h1>Facebook Window</h1>" )
    else
      $('#test').append( "<h1>Normal Window</h1>" )
  
  catch e 
    $('#test').append( "<h1>Facebook Window</h1>" )
   

  $('#slider').slippry
    transition: 'vertical'
    captions: 'custom'
    captionsEl: '.browser-mockup-captions'
    pause: 6000


  onLearnMore = (e) ->
    e.preventDefault()
    console.log 'learning more'
    FB.Canvas.scrollTo(0,$('#learn-more-section').position().top + 42)

  $(document).on 'click', '#learn-more', onLearnMore