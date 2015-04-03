$ ->
  onShare = (e) ->
    e.preventDefault()
    share_url = $(e.currentTarget).data('share-url')
    
    FB.ui {
      method: 'share'
      href: share_url 
    }, (response) ->
      console.log response


  $(document).on 'click', '#share', onShare