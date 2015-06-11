(($, window, document) ->

  # define your widget under a namespace of your choice
  #  with additional parameters e.g.
  # $.widget( "namespace.widgetname", (optional) - an
  # existing widget prototype to inherit from, an object
  # literal to become the widget's prototype );

  $.widget 'surzycki.pageTransitions',
    #Setup widget (eg. element creation, apply theming
    # , bind events etc.)
    _create: ->
     
    # Destroy an instantiated plugin and clean up
    # modifications the widget has made to the DOM
    destroy: ->
      $.Widget::destroy.call @

    nextPage: ->
      outpage = @get_current_page()
      inpage  = @get_next_page()

      # no in page or in the middle of an animation, return
      return false if (inpage.length == 0) || @isAnimating

      @isAnimating = true

      # make inpage visable during transition
      inpage.addClass('page-transition-page-current')
      # get animation classes
      @animations = @_getAnimationClasses(outpage.data('animation'))

      # animate
      outpage.addClass(@animations.next.out).one @_animEndEventNames, =>
        @_end_current_page = true
        @_onEndAnimation(outpage, inpage) if @_end_next_page

      inpage.addClass(@animations.next.in).one @_animEndEventNames, =>
        @_end_next_page = true
        @_onEndAnimation(outpage, inpage ) if @_end_current_page

      return true

    previousPage: -> 
      outpage = @get_current_page()
      inpage  = @get_previous_page()

      # no in page or in the middle of an animation, return
      return false if (inpage.length == 0) || @isAnimating

      @isAnimating = true

      # make inpage visable during transition
      inpage.addClass('page-transition-page-current')
      # get animation classes
      @animations = @_getAnimationClasses(outpage.data('animation'))

      # animate
      outpage.addClass(@animations.prev.in).one @_animEndEventNames, =>
        @_end_current_page = true
        @_onEndAnimation(outpage, inpage) if @_end_prev_page

      inpage.addClass(@animations.prev.out).one @_animEndEventNames, =>
        @_end_prev_page = true
        @_onEndAnimation(outpage, inpage ) if @_end_current_page

      return true

    get_current_page: -> 
      $('#page-transition-pages').find('.page-transition-page-current')

    get_next_page: ->
      $('#page-transition-pages').find('.page-transition-page-current').next()

    get_previous_page: ->
      $('#page-transition-pages').find('.page-transition-page-current').prev()


    _onEndAnimation: (outpage, inpage)  -> 
      @_end_next_page    = false
      @_end_current_page = false
      @_end_prev_page    = false

      @_resetPage(outpage, inpage)

      @isAnimating = false

    _resetPage: (outpage, inpage) -> 
      outpage.removeClass('page-transition-page-current')
      
      outpage.removeClass(@animations.next.out)
      inpage.removeClass(@animations.next.in)
      outpage.removeClass(@animations.prev.in)
      inpage.removeClass(@animations.prev.out)

    _animEndEventNames:
      'webkitAnimationEnd oanimationend msAnimationEnd animationend'

    _getAnimationClasses: (type) ->
      switch type
        when 'slideLeft'
          { 
            next: { out: 'moveToLeft', in: 'moveFromRight' }, 
            prev: { out: 'moveFromLeft', in: 'moveToRight' }
          }
        
        when 'foldTopFromBottom'
          { 
            next: { out: 'rotateFoldTop', in: 'moveFromBottomFade' }, 
            prev: { out: 'moveFromTopFade', in: 'rotateFoldBottom' }
          }

        when 'foldBottomFromTop'
          { 
            next: { out: 'rotateFoldBottom', in: 'moveFromTopFade' }, 
            prev: { out: 'moveFromBottomFade', in: 'rotateFoldTop' }
          }

        when 'scaleDownRight'
          { 
            next: { out: 'scaleDown', in: 'moveFromRight page-transition-page-ontop' }, 
            prev: { out: 'moveFromLeft page-transition-page-ontop', in: 'scaleDown' }
          }

        when 'moveBottomFromTop'
          { 
            next: { out: 'moveToBottom', in: 'moveFromTop' }, 
            prev: { out: 'moveFromBottom', in: 'moveToTop' }
          }

        when 'roomToBottom'
          { 
            next: { out: 'rotateRoomBottomOut page-transition-page-ontop', in: 'rotateRoomBottomIn' }, 
            prev: { out: '', in: '' }
          }

        when 'moveBottomScaleUp'
          { 
            next: { out: 'moveToBottom page-transition-page-ontop', in: 'scaleUp' }, 
            prev: { out: 'moveFromBottom page-transition-page-ontop', in: 'scaleDown' }
          }

        when 'scaleUp'
          { 
            next: { out: 'scaleDownUp', in: 'scaleUp page-transition-page-delay100' }, 
            prev: { out: 'moveFromBottom page-transition-page-ontop', in: 'scaleDown' }
          }

        when 'glueBottomTop'
          { 
            next: { out: 'rotateTopSideFirst', in: 'moveFromTop page-transition-page-delay200 page-transition-page-ontop' }, 
            prev: { out: 'moveFromBottom page-transition-page-delay200 page-transition-page-ontop', in: 'rotateBottomSideFirst' }
          }

        when 'pushBottomPullTop'
          { 
            next: { out: 'rotatePushBottom', in: 'rotatePullTop page-transition-page-delay200' }, 
            prev: { out: 'rotatePullBottom page-transition-page-delay200', in: 'rotatePushTop' }
          }

        when 'flipLeft'
          { 
            next: { out: 'flipOutLeft', in: 'flipInRight page-transition-page-delay500' }, 
            prev: { out: '', in: '' }
          }

        else
          { 
            next: { out: 'moveToLeft', in: 'moveFromRight' }, 
            prev: { out: 'moveFromLeft', in: 'moveToRight' }
          }
  
  return
) jQuery, window, document

