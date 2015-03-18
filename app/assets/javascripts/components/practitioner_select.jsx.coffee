root = exports ? this

root.PractitionerSelect = React.createClass(
  propTypes: 
    field:  React.PropTypes.string

  componentWillMount: ->
    this.props.name       = "#{this.props.form}[#{this.props.field}]"
    this.props.id         = "#{this.props.form}_#{this.props.field}"
    this.props.className  = "#{this.props.className} typeahead"

  componentDidMount: ->
    element = this.getDOMNode()
    
    $(element).typeahead {
      hint: true
      highlight: true
      minLength: 1
    },
      name: 'states'
      displayKey: 'value'
      source: this.substringMatcher(['Indiana','Idaho','Illinois','Irresponsible'])
    
    console.log 'mounted'

  componentWillUnmount: ->
    console.log 'will unmount'

  substringMatcher: (strs) ->
    (q, cb) ->
      matches = undefined
      substrRegex = undefined
      # an array that will be populated with substring matches
      matches = []
      # regex used to determine if a string contains the substring `q`
      substrRegex = new RegExp(q, 'i')
      # iterate through the pool of strings and for any string that
      # contains the substring `q`, add it to the `matches` array
      $.each strs, (i, str) ->
        if substrRegex.test(str)
          # the typeahead jQuery plugin expects suggestions to a
          # JavaScript object, refer to typeahead docs for more info
          matches.push value: str
        return
      cb matches
      return

  render: ->
    `<input type='search' name={ this.props.name } id={ this.props.id } ref='input' 
        className={ this.props.className } placeholder={ this.props.placeholder } />`

    
)
