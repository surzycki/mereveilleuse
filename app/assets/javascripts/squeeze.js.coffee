$ ->
 
  onScrollTo = (e) ->
    e.preventDefault()
  
    id = $(e.currentTarget).attr('id')
    scroll_target = "##{id.replace('x-', '')}"

    if window.is_canvas()
      FB.Canvas.scrollTo(0,$(scroll_target).position().top + 42)
    else
      $.scrollTo($(scroll_target), 300)


  $(document).on 'click', '#x-more-information', onScrollTo
  $(document).on 'click', '#x-join', onScrollTo
  $(document).on 'click', '#x-develop', onScrollTo
  $(document).on 'click', '#x-benefit', onScrollTo
  $(document).on 'click', '#x-contact', onScrollTo
  $(document).on 'click', '#x-squeeze-conversion', onScrollTo