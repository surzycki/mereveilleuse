root = exports ? this

root.FacebookCanvasLogin = React.createClass(  
  # The user is on a facebook canvas page.  Facebook sends up status changes
  # that which we must monitor; there are several cases we need to handle
  #
  # 1. NOT connected (not_authorized), so login the user
  # 2. connected, decided in what phase we are:
  #     * accepting facebook permissions
  #     * accepted facebook permissions
  mixins: [CanvasUtilsMixin]

  getInitialState: ->
    is_loaded: 'unloaded'
    status: 'not_connected'

  componentWillMount: ->
    if this.isFacebookCanvas()
      PubSub.subscribe( 'facebook:sdk:status:changed', this._handleStatusChange )
      
  render: ->
    `<meta property='FacebookCanvasLogin' content={this.state.is_loaded} name={this.state.status}/>`

  login: (callback) ->
    # We either
    # 1. login
    # 2. display permissions
    FB.login callback, scope: 'public_profile, user_friends, email, user_location'

  _handleStatusChange: (msg, response) ->
    this.setState
      is_loaded: 'loaded'
      status: response.status

    if response.status != 'connected'
      this.login this._handleLogin
    else
      # 1. accepting facebook permission (requesting_authentication == true)
      #    in which case we need to reload to page to pass the new
      #    signed request to the backend
      # 2. already accepted facebook permissions
      if this.props.facebook_permissions_dialog == 'true'
        top.location.href = this.props.facebook_canvas

  _handleLogin: (response) ->
    # We either
    # 1. accepted facebook permissions and logged in
    # 2. denied facebook permissions and are redirected 
    if response.status != 'connected' 
      top.location.href = 'https://www.facebook.com/games/mereveilleuse/'

)