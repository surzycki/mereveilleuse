root = exports ? this

root.PatientTypeSelect = React.createClass(
  getInitialState: ->
    value: null

  handleChange: (event) ->
    this.setState(
      value: event.target.value
    )

    this.props.className = this.props.className + ' ' + 'black'

  render: ->
    cx  = React.addons.classSet
    classes = cx(
      'form-control': true
      'black': @state.value
    )


    `<select className={classes} name={ this.props.name } id={ this.props.id } onChange={this.handleChange} value={this.state.value}>
      <option value="">{this.props.placeholder}</option>
      {this.options()}
    </select>`

  options: ->
    for patient_type in JSON.parse(this.props.children.toString())
      `<option value={patient_type[1]}>{patient_type[0]}</option>`
)