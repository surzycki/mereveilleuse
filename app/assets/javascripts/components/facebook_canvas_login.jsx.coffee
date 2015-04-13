root = exports ? this

root.FacebookCanvasLogin = React.createClass(  
  # The user is on a facebook canvas page.  Facebook sends up status changes
  # that which we must monitor; there are several cases we need to handle
  #
  # 1. NOT connected (not_authorized), so login the user
  # 2. connected, decided in what phase we are:
  #     * accepting facebook permissions
  #     * accepted facebook permissions
  getInitialState: ->
    is_loaded: 'unloaded'

  componentDidMount: ->
    if window.is_canvas()
      this.setState(is_loaded: 'loaded')
      FB.Event.subscribe 'auth.statusChange', this.onStatusChange

  render: ->
    `<meta property='FacebookCanvasLogin' content={this.state.is_loaded}/>`

  login: (callback) ->
    # We either
    # 1. login
    # 2. display permissions
    FB.login callback, scope: 'public_profile, user_friends, email, user_location'

  onStatusChange: (response) ->
    console.log response
    if response.status != 'connected'
      this.login this._loginCallback
    else
      # 1. accepting facebook permission (requesting_authentication == true)
      # 2. already accepted facebook permissions
      if this.props.facebook_permissions_dialog == 'true'
        console.log 'CANVAS:onStatusChange: reload page'
        top.location.href = this.props.facebook_canvas

  _loginCallback: (response) ->
    # We either
    # 1. accepted facebook permissions and logged in
    # 2. denined facebook permissions and are redirected
    
    console.log('CANVAS:loginCallback:' + response.status);
    if response.status != 'connected' 
      top.location.href = 'https://www.facebook.com/games/mereveilleuse/'

)