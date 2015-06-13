root = exports ? this

root.FacebookInviteButton = React.createClass(  
  # Send invites to facebook friends
  
  handleClick: (event) ->
    event.preventDefault()
    PubSub.publish( 'mixpanel:sdk:track:event', 'recommendation:invite:opened' )
    this.sendInvite()

  render: ->
    `<a className={this.props.class} href='#dialog' onClick={this.handleClick}>
      {this.props.value}
    </a>`

  sendInvite: ->
    options = 
      method: 'apprequests'
      message: this.props.message

    FB.init
      appId: '869143069794965'
      version: 'v2.2'

    FB.ui options, this._onResponse

  _onResponse: (response) ->
    if response.request
      PubSub.publish( 'mixpanel:sdk:track:event', 'recommendation:invite:sent' )

    # if we sent items AND there is a redirect url, lets go!
    if this.props.redirect && response.request
      window.location = this.props.redirect
)

