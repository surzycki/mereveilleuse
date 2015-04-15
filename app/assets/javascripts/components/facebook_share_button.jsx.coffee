root = exports ? this

root.FacebookShareButton = React.createClass(  
  # Send shares to facebook friends
  
  handleClick: (event) ->
    event.preventDefault()
    PubSub.publish( 'mixpanel:sdk:track:event', 'recommendation:share:opened' )
    this.sendInvite()

  render: ->
    `<a className={this.props.class} href='#dialog' onClick={this.handleClick}>
      {this.props.value}
    </a>`

  sendInvite: ->
    options = 
      method: 'share'
      href: this.props.url

    FB.ui options, this._onResponse

  _onResponse: (response) ->
    return if response == undefined 
    return if response.error_code 
    
    PubSub.publish( 'mixpanel:sdk:track:event', 'recommendation:share:sent' )

)

