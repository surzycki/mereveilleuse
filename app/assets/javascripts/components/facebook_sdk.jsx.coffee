root = exports ? this

root.FacebookSDK = React.createClass(
  # Creating and loading the facebook js sdk in a react component
  # we want to tie this all together in react so the async loading nature
  # of the js-sdk does not cause random undefined errors

  componentDidMount: ->
    window.fbAsyncInit = ->
      FB.init
        appId: ''
        xfbml: false
        cookie: true
        status: true
        version: 'v2.2'
    
    # Load the SDK asynchronously
    ((d, s, id) ->
      js = undefined
      fjs = d.getElementsByTagName(s)[0]
      if d.getElementById(id)
        return
      js = d.createElement(s)
      js.id = id
      js.src = '//connect.facebook.net/en_US/sdk.js'
      fjs.parentNode.insertBefore js, fjs
      return
    ) document, 'script', 'facebook-jssdk'  
)

