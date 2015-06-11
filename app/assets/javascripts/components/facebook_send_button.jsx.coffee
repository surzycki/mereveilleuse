root = exports ? this

root.FacebookSendButton = React.createClass(  
  # Send message to friends
  # see: https://developers.facebook.com/docs/sharing/reference/send-dialog
  
  handleClick: (event) ->
    event.preventDefault()
    PubSub.publish( 'mixpanel:sdk:track:event', 'registration:invite:opened' )
    this.sendDialog()

  render: ->
    `<a className={this.props.class} href='#dialog' onClick={this.handleClick}>
      {this.props.value}
    </a>`

  sendDialog: ->
    options = 
      method: 'send'
      link: this.props.url

    FB.ui options, this._onResponse

  _onResponse: (response) ->
    if response.request
      PubSub.publish( 'mixpanel:sdk:track:event', 'registration:invite:sent' )

    # if we sent items AND there is a redirect url, lets go!
    #if this.props.redirect && response.request
    #  window.location = this.props.redirect
)

