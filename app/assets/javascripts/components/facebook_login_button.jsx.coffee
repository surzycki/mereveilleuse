root = exports ? this

root.FacebookLoginButton = React.createClass(

  handleClick: (event) ->
    console.log 'clicked'
    debugger

  render: ->
    `<a className='btn btn-primary btn-block' hfre='#' onClick={ this.handleClick }>Here</a>`

)
  
