root = exports ? this

root.ProfessionAutocomplete = React.createClass(
  propTypes: 
    field:  React.PropTypes.string

  getInitialState: ->
    value: null
  
  componentWillMount: ->
    PubSub.subscribe( 'practitioner:selected', this.handlePractitionerSelected )

  componentDidMount: ->
    this._initialize_typeahead()
    
  componentWillUnmount: ->
    this._destroy_typeahead()
   
  engine: -> 
    new Bloodhound(
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name')
      queryTokenizer: Bloodhound.tokenizers.whitespace
      remote: 
        url: '/professions/autocomplete?query=%QUERY'
    )

  handleChange: (event) ->
    this.setState(
      value: event.target.value
    )

    # send clear event
    this._clear(event.target.value) 
    
  handlePractitionerSelected: (msg, data) ->
    this.setState(
      value: data.profession_name
    )
    
    this._clear(data.profession_name)

  render: ->
    `<div>
     <input type='text' name={ this.props.name } id={ this.props.id } ref='input' 
        className={ this.props.className } placeholder={ this.props.placeholder } value={this.state.value} onChange={this.handleChange}  />
    </div>`  
   

  _clear: (value) ->
   
  _initialize_typeahead: ->
    profession_engine = this.engine()
    profession_engine.initialize()

    element = this.refs.input.getDOMNode()
    
    $(element).typeahead { 
      hint: true
      highlight: true
      minLength: 2
    },
      name: 'profession_name'
      displayKey: 'name'
      source: profession_engine.ttAdapter()

    $(element).on 'typeahead:selected', (jquery, option) =>
      this.setState(
        value: option.name
      ) 

  _destroy_typeahead: ->
    element = this.getDOMNode()
    $(element).typeahead('destroy')
    
)
