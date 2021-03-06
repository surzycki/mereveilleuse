root = exports ? this

root.FacebookLoginButton = React.createClass(  
  # The user is clicking to join, we will ask facebook what is
  # thier status, it can be one of three possibilities
  #
  # 1. Logged into your app ('connected')
  # 2. Logged into Facebook, but not your app ('not_authorized')
  # 3. Not logged into Facebook and can't tell if they are logged into
  #    your app or not.
  #
  # These three cases are handled in the callback function.
  mixins: [CanvasUtilsMixin]


  # Either we are:
  #
  # 1. On the canvas, so redirect, we are already logged in
  # 2. We are not on the canvas and we need to be logged in, after which
  #    a POST happens to the session controller to login the user from an app
  #    perspective
  #    NOTE:  There is no guarentee that any chain of events begun by the 
  #           logging into facbeook will complete before the submit to the controller happens
  #           if this is the case then you can forget whatever was happening in that chain, it is gone
  handleSubmit: (event) ->
    event.preventDefault()
    form = this.refs.form.getDOMNode()
    
    this._trackEvent()

    if this.isFacebookCanvas()
      window.location = this.props.canvas_link
    else
      FB.login ((response) =>
        this._handleFacebookConnect(response, form)
      ), scope: 'public_profile, user_friends, email, user_location'


  render: ->
    `<form ref='form' action={this.props.facebook_connect_path} method='post' onSubmit={this.handleSubmit} id={this.props.id}>
      <input type='submit' value={this.props.value} className={this.props.class} />
    </form>`


  _handleFacebookConnect: (response, form) ->
    if response.status != 'connected' 
      window.location.href = 'https://www.facebook.com/games/mereveilleuse/'
    else
      form.submit()


  _trackEvent: () ->
    if this.props.id == 'x-join-top'
      event = 'acquisition:login:top'
    else
      event = 'acquisition:login:bottom'

    PubSub.publish( 'mixpanel:sdk:track:event', event )
)
  
