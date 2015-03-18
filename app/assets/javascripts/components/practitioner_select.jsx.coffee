root = exports ? this

root.PractitionerSelect = React.createClass(
  propTypes: 
    name:        React.PropTypes.string
    class:       React.PropTypes.string
    placeholder: React.PropTypes.string
  
  componentDidMount: ->
    console.log 'mounted'

  componentWillUnmount: ->
    console.log 'will unmount'

  render: ->
    `<input type='search' name='recommendation_form[practitioner_name]' id='recommendation_form_practitioner_name' ref='input' 
        className={this.props.class} 
        placeholder={this.props.placeholder} />`

    
)
