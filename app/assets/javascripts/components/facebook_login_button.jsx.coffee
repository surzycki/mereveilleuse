root = exports ? this

root.FacebookLoginButton = React.createClass(
  getInitialState: ->
    signed_request: ''
    
  # The user is clicking to join, we will ask facebook what is
  # thier status, it can be one of three possibilities
  #
  # 1. Logged into your app ('connected')
  # 2. Logged into Facebook, but not your app ('not_authorized')
  # 3. Not logged into Facebook and can't tell if they are logged into
  #    your app or not.
  #
  # These three cases are handled in the callback function.
  handleSubmit: (event) ->
    event.preventDefault()
    form = this.refs.form.getDOMNode()
    
    FB.login ((response) =>
      this._handleFacebookConnect(response, form)
    ), scope: 'public_profile, user_friends, email, user_location'

  render: ->
    `<form ref='form' action='session/canvas' method='post' onSubmit={this.handleSubmit}>
      <input type='submit' value='Submit' className='btn btn-primary btn-block'/>
      <input type='hidden' name='signed_request' value={this.state.signed_request}/>
    </form>`

  _handleFacebookConnect: (response, form) ->
    this.setState(signed_request: response.authResponse.signedRequest)
    form.submit()
)
  
