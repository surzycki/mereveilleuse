root = exports ? this

root.PractitionerSelect = React.createClass(
  propTypes: 
    field:  React.PropTypes.string

  componentWillMount: ->
    this.props.name = "#{this.props.form}[#{this.props.field}]"
    this.props.id   = "#{this.props.form}_#{this.props.field}"
    
  componentDidMount: ->
    console.log 'mounted'

  componentWillUnmount: ->
    console.log 'will unmount'

  render: ->
    `<input type='search' name={ this.props.name } id={ this.props.id } ref='input' 
        className={ this.props.className } placeholder={ this.props.placeholder } />`

    
)
