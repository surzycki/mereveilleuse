root = exports ? this

root.FacebookSDK = React.createClass(
  # Creating and loading the facebook js sdk in a react component
  # we want to tie this all together in react so the async loading nature
  # of the js-sdk does not cause random undefined errors
  getInitialState: ->
    is_loaded: 'unloaded'
    platform: 'web'

  componentDidMount: ->
    window.fbAsyncInit = =>
      FB.init
        appId: this.props.app_id
        xfbml: false
        cookie: true
        status: true
        version: 'v2.2'
    
      if(window.is_canvas())
        FB.Canvas.setAutoGrow(91)
        FB.Canvas.scrollTo(0,0)
        FB.Event.subscribe 'auth.statusChange', this._onStatusChange
        this.setState(platform: 'canvas')
      
      this.setState(is_loaded: 'loaded')

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

  render: ->
    `<meta property='FacebookSDK' content={this.state.is_loaded} name={this.state.platform}/>` 

  _onStatusChange: (response) ->
    # broadcast to interested components
    PubSub.publish( 'facebook:sdk:status:changed', response )
)

