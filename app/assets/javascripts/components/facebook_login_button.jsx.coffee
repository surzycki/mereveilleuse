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
    form.submit()

  _trackEvent: () ->
    if this.props.id == 'x-join-top'
      event = 'acquisition:login:top'
    else
      event = 'acquisition:login:bottom'

    PubSub.publish( 'mixpanel:sdk:track:event', event )
)
  
