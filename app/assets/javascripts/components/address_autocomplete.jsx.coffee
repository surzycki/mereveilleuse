root = exports ? this

root.AddressAutocomplete = React.createClass(
  propTypes: 
    field:  React.PropTypes.string

  getInitialState: ->
    value: null
    icon: 'icon-ok hidden'

  componentWillMount: ->
    PubSub.subscribe( 'practitioner:selected', this.handlePractitionerSelected )

    # parse the input field
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
    new AddressPicker
      autocompleteService:
        types: ['geocode']
        
        componentRestrictions:
          country: 'FR'

  handleChange: (event) ->
    this.setState(
      value: event.target.value
      icon: 'icon-ok'
    ) 
    # send clear event
    this._clear(event.target.value)

  handlePractitionerSelected: (msg, data) ->
    this.setState(
      value: data.address
      icon: 'icon-ok'
    )
    
    this._clear(data.address)
    
  render: ->
    `<div>
    <input type='search' name={ this._props.name } id={ this._props.id } ref='input' data-error={ this._props.data_error }
        className={ this._props.className } placeholder={ this._props.placeholder } value={this.state.value} onChange={this.handleChange}  />
    <i className={this.state.icon}/>
    </div>` 
  
  _props: {}

  _clear: (value) ->
    if value == ''
      this.setState(icon: 'icon-ok hidden')

  _initialize_typeahead: ->
    addressPicker = this.engine()
    
    element = this.refs.input.getDOMNode()
    
    $(element).typeahead { 
      hint: true
      highlight: true
      minLength: 2
    },
      name: 'address_autocomplete'
      displayKey: 'description'
      source: addressPicker.ttAdapter()

    $(element).on 'typeahead:selected', (jquery, option) ->
      console.log(option)

  _destroy_typeahead: ->
    element = this.getDOMNode()
    $(element).typeahead('destroy')
    PubSub.unsubscribe( this.handlePractitionerSelected )

)
