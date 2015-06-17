root = exports ? this

root.RecommendationFormStep = React.createClass(
  
  getInitialState: ->
    error_practitioner: false
    error_profession: false
    error_address: false
    patient_type: false

  handleClick: (event) ->
    event.preventDefault()
    
    this.resetFields()

    if @refs.practitioner.state.value && @refs.profession.state.value && @refs.address.state.value && @refs.patient_type.state.value
      $('#page-transition-pages').pageTransitions()
      $('#page-transition-pages').pageTransitions('nextPage')
    else
      this.setState(
        error_patient_type: not(@refs.patient_type.state.value?.length)
        error_practitioner: not(@refs.practitioner.state.value?.length)
        error_profession: not(@refs.profession.state.value?.length)
        error_address: not(@refs.address.state.value?.length)
      ) 

  render: ->
    cx  = React.addons.classSet
    
    patient_type_classes = cx(
      'form-group': true
      'mobile-stretch-content': true
      'validation-error': @state.error_patient_type)

    practitioner_classes = cx(
      'form-group': true
      'mobile-stretch-content': true
      'validation-error': @state.error_practitioner)

    profession_classes = cx(
      'form-group': true
      'mobile-stretch-content': true
      'validation-error': @state.error_profession)

    address_classes = cx(
      'form-group': true
      'mobile-stretch-content': true
      'validation-error': @state.error_address)

    `<div className='mobile-stretch-wrapper'>
      <div className='mobile-stretch-content'>
        <h3>Do recommendation</h3>
      </div>

      <div className={patient_type_classes}>
        <PatientTypeSelect ref='patient_type' className='form-control' name='recommendation_form[patient_type_id]' id='recommendation_form_patient_type_id' placeholder='Précisez pour qui'>{this.props.patient_types}</PatientTypeSelect>
      </div>

      <div className={practitioner_classes}>
        <PractitionerAutocomplete ref='practitioner' className='form-control' name='recommendation_form[practitioner_name]' id='recommendation_form_practitioner_name' placeholder='Nom du professionnel'></PractitionerAutocomplete>
      </div>

      <div className={profession_classes}>
        <ProfessionAutocomplete ref='profession' className='form-control' name='recommendation_form[profession_name]' id='recommendation_form_profession_name' placeholder='La profession'></ProfessionAutocomplete>
      </div>

      <div className={address_classes}>
        <AddressAutocomplete ref='address' className='form-control' name='recommendation_form[address]' id='recommendation_form_address' placeholder="Renseignez l'adresse"></AddressAutocomplete>
      </div>
      
      <div className='form-group mobile-stretch-content'>
        <a className='btn btn-primary' onClick={this.handleClick}>Go</a>
      </div>
    </div>` 

  resetFields: () ->
    this.setState(
      error_patient_type: false
      error_practitioner: false
      error_profession: false
      error_address: false
    ) 
)