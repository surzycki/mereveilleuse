root = exports ? this

root.AddressAutocomplete = React.createClass(
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
    new AddressPicker
      autocompleteService:
        types: ['geocode']
        
        componentRestrictions:
          country: 'FR'

  handleChange: (event) ->
    this.setState(
      value: event.target.value
    ) 
    # send clear event
    this._clear(event.target.value)

  handlePractitionerSelected: (msg, data) ->
    this.setState(
      value: data.address
    )
    
    this._clear(data.address)
    
  render: ->
    `<div>
    <input type='text' name={ this.props.name } id={ this.props.id } ref='input' 
        className={ this.props.className } placeholder={ this.props.placeholder } value={this.state.value} onChange={this.handleChange}  />
    </div>` 
  
  _clear: (value) ->
    
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

    $(element).on 'typeahead:selected', (jquery, option) =>
      this.setState(
        value: option.description
      ) 

  _destroy_typeahead: ->
    element = this.getDOMNode()
    $(element).typeahead('destroy')
    PubSub.unsubscribe( this.handlePractitionerSelected )

)
