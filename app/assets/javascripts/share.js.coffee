$ ->
  onShare = ->
    FB.ui {
      method: 'share'
      href: 'https://apps.facebook.com/mereveilleuse-dev/'
    }, (response) ->
      console.log response


  $(document).on 'click', '#share', onShare