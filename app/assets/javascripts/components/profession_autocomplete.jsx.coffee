root = exports ? this

root.ProfessionAutocomplete = React.createClass(
  propTypes: 
    field:  React.PropTypes.string

  getInitialState: ->
    value: null;
  
  componentWillMount: ->
    PubSub.subscribe( 'practitioner:selected', this.handlePractitionerSelected )

    input  = $.parseHTML(this.props.field)
   
    this._props.name        = $(input).attr('name')
    this._props.id          = $(input).attr('id')
    this._props.className   = "#{$(input).attr('class')} typeahead"
    this._props.placeholder = $(input).attr('placeholder')
    this._props.data_error  = $(input).attr('data-error')
    
    this.setState( { value: $(input).attr('value') } ) 

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

  handleChange: ->
    this.setState( { value: event.target.value } ) 
    # send clear event
    #if event.target.value == ''
    #  PubSub.publish( 'practitioner:selected', { address: ''} );

  handlePractitionerSelected: (msg, data) ->
    this.setState( { value: data.profession_name } )

  render: ->
    `<input type='search' name={ this._props.name } id={ this._props.id } ref='input' data-error={ this._props.data_error }
        className={ this._props.className } placeholder={ this._props.placeholder } value={this.state.value} onChange={this.handleChange}  />`
   

  _props: {}

  _initialize_typeahead: ->
    practitioner_engine = this.engine()
    practitioner_engine.initialize()

    element = this.getDOMNode()
    
    $(element).typeahead { 
      hint: true
      highlight: true
      minLength: 2
    },
      name: 'profession_name'
      displayKey: 'name'
      source: practitioner_engine.ttAdapter()

  _destroy_typeahead: ->
    element = this.getDOMNode()
    $(element).typeahead('destroy')
    
)
