$ ->
  # load facebook sdk
  $.ajaxSetup cache: true
  $.getScript '//connect.facebook.net/en_US/sdk.js'

  # remove 300ms wait in ios
  FastClick.attach(document.body)
  # prevent elastic scroll in mobile
  $(document).bind 'touchmove', (e) ->
    e.preventDefault()
  
  # setup clicks to change pages
  $('body').on 'click', '#registration-start, .rating-input label, #search-start, #registration-influencer-next', (e) ->
    $('#page-transition-pages').pageTransitions()
    $('#page-transition-pages').pageTransitions('nextPage')

  # setup form submission for reccomendation
  $('body').on 'click', '#recommendation-commit', (e) ->
    $('#recommendation_form').attr('action',$('#recommendation_form').data('action'))
    $('#recommendation_form').submit()

  # allow smooth transitions between page loads
  $('#main').smoothState(
    prefetch: false
    anchors: '#registration-influencer, #registration-know-influencer, #registration-back'

    onStart: 
      duration: 700
      render: (container) ->
        # animate out
        container.addClass('scaleDown')
    
    onReady: 
      duration: 700
      render: (container, newContent)  ->
        # add content
        container.html(newContent)
        # need to initialize components
        ReactRailsUJS.mountComponents()
        
        # animate in
        container.removeClass('scaleDown')
        container.addClass('scaleUp')

    onAfter: (container, newContent) ->
      # clean up and re-init
      container.removeClass('scaleUp')
      #$('#new_recommendation_form').swipe swipe: (event, direction, distance, duration, fingerCount, fingerData) ->
      #  if (direction == 'up')
      #    $('#page-transition-pages').pageTransitions('previousPage')
  )

  
     



  
  