root = exports ? this

root.PractitionerAutocomplete = React.createClass(
  propTypes: 
    field:  React.PropTypes.string

  getInitialState: ->
    value: null
    
  componentWillMount: ->
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

  render: ->
    `<div>
      <input type='search' name={ this._props.name } id={ this._props.id } ref='input' data-error={ this._props.data_error }
        className={ this._props.className } placeholder={ this._props.placeholder } value={this.state.value} onChange={this.handleChange}  />
    </div>`
   

  _props: {}

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
      


    $(element).on 'typeahead:selected', (jquery, option) ->
      PubSub.publish( 'practitioner:selected', option );

  _destroy_typeahead: ->
    element = this.getDOMNode()
    $(element).typeahead('destroy')
    

)
