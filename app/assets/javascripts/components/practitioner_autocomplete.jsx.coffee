root = exports ? this

root.PractitionerAutocomplete = React.createClass(
  propTypes: 
    field:  React.PropTypes.string

  getInitialState: ->
    value: null
    
  componentDidMount: ->
    this._initialize_typeahead()
    
  componentWillUnmount: ->
    this._destroy_typeahead()
   
  engine: -> 
    new Bloodhound(
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('fullname')
      queryTokenizer: Bloodhound.tokenizers.whitespace
      remote: 
        url: '/practitioners/autocomplete?query=%QUERY'
    )

  handleChange: (event) ->
    this.setState(
      value: event.target.value
    ) 
    # send clear event
    this._clear(event.target.value)

  handleKey: (event) ->
    if event.keyCode == 13
      this.refs.input.getDOMNode().blur()
    

  render: ->
    `<div>
      <input type='text' name={ this.props.name } id={ this.props.id } ref='input' 
        className={ this.props.className } placeholder={ this.props.placeholder } value={this.state.value} onChange={this.handleChange} onKeyUp={this.handleKey}  />
    </div>`
   

  _clear: (value) ->
    if value == ''
      PubSub.publish( 'practitioner:selected', { address: '', profession_name: ''} )

  _initialize_typeahead: ->
    practitioner_engine = this.engine()
    practitioner_engine.initialize()

    element = this.refs.input.getDOMNode()
    
    $(element).typeahead { 
      hint: true
      highlight: true
      minLength: 2
    },
      name: 'practitioner_name'
      displayKey: 'fullname'
      source: practitioner_engine.ttAdapter()
      

    $(element).on 'typeahead:selected', (jquery, option) =>
      @setState(
        value: option.fullname
      ) 

      PubSub.publish( 'practitioner:selected', option );

  _destroy_typeahead: ->
    element = @getDOMNode()
    $(element).typeahead('destroy')
    

)
