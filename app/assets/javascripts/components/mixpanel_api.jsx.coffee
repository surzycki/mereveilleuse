root = exports ? this

root.MixpanelAPI = React.createClass(
  # We will be listening for notification sent by the facebook sdk
  # these notifications are:
  #
  # 1. LOGIN, in which the user first logs into the platform during this time
  #    the user is accepting the permissions and/or logging into facebook (if permissions 
  #    have already been accepted)
  # 2. CHANGED, in which the user arrives at the site or page view and he/she is
  #    already logged in and authenticated with facebook
  mixins: [CanvasUtilsMixin]

  getInitialState: ->
    is_loaded: 'unloaded'
    identity: 'unknown'
    is_first_time: 'unknown'

  componentWillMount: ->
    return unless window.mixpanel 

    this.setState(is_loaded: 'loaded', is_first_time: this.getIsFirstTime())
    PubSub.subscribe( 'facebook:sdk:status:changed', this._handleStatusChanged )
    PubSub.subscribe( 'facebook:sdk:status:login', this._handleStatusLogin )
    PubSub.subscribe( 'mixpanel:sdk:track:event', this._handleMixpanelEvents )
    mixpanel.track_forms('#new_recommendation_form', 'activation:recommend')
    mixpanel.track_forms('#new_search_form','activation:search')


  render: ->
    `<meta property='MixpanelAPI' content={this.state.is_loaded} name={this.state.identity} data-first-time={this.state.is_first_time}/>`


  getPlatform: ->
    if this.isFacebookCanvas() 
      platform = 'canvas'
    else
      platform = 'web'

    platform   

  # determins if the user is a first time visitor.
  # A user is considered first time if:
  # 
  # 1. There is a NOT a timestamp cookie present 
  # 2. Or the cookie is present but was set less than 1hr ago
  getIsFirstTime: -> 
    stored_timestamp = parseInt($.cookie('timestamp'))
  
    if stored_timestamp && ((stored_timestamp + 3600000) < this._timestamp())
      return false
    else
      value = this._timestamp()
      $.cookie('timestamp', value, { expires: 365 })
      return true

  # Called on every page including the facebook sdk
  # It helps to determin the current status of the user
  # vis-a-vis facebook
  _handleStatusChanged: (msg, response) ->
    console.log '_handleStatusChanged'
    console.log response

    $.when(this._getFacebookData(response)).done (response) =>
      this.setState(identity: response.id)
      this._registerProperties(response)
      this._createProfile(response)
      mixpanel.people.increment('page views', 1)
      mixpanel.track('retention:page:view')
    
    if response.status == 'not_authorized'
      mixpanel.track('acquisition:unauthenticated')      


  # Called when logging in for the first time
  # generally happening when signing up for the first time
  _handleStatusLogin: (msg, response) ->
    console.log '_handleStatusLogin'
    console.log response
    
    mixpanel.register
      'Platform': this.getPlatform()

    mixpanel.track('acquisition:permissions:dialog')


  # Called by other components to register an event, in this way
  # other components don't have to track the existance (or not)
  # of the mixpanel object
  _handleMixpanelEvents: (msg, event) ->
    mixpanel.track(event)
  

  _getFacebookData: (response) ->
    deferred = $.Deferred()

    if response.status == 'connected'
      FB.api '/me', { fields: 'name, first_name, last_name, email, gender, location' }, (response) ->
        deferred.resolve(response)
    else
      deferred.reject()

    deferred.promise()
  

  _registerProperties: (information) ->
    # link previous behaviour to this account 
    distinct_id = mixpanel.get_distinct_id()
    console.log "_registerProperties: #{distinct_id}"
    console.log "_registerProperties: #{information.id}"
    mixpanel.alias(information.id, distinct_id)
      
    location = information.location if information.location

    mixpanel.register
      'Gender': information.gender
      'Location': location.name
      'Platform': this.getPlatform()
      'FirstTime': this.getIsFirstTime()

  _createProfile: (information) ->
    distinct_id = mixpanel.get_distinct_id()
    console.log "_createProfile: #{distinct_id}"
    console.log "_createProfile: #{information.id}"

    mixpanel.identify(information.id)
    mixpanel.people.set
      $email: information.email
      $first_name: information.first_name
      $last_name: information.last_name
      gender: information.gender 
      platform: this.getPlatform()

  _timestamp: -> 
    new Date().getTime()
)