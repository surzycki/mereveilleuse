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


  componentDidMount: ->
    if window.mixpanel 
      this.setState(is_loaded: 'loaded')
      PubSub.subscribe( 'facebook:sdk:status:changed', this._handleStatusChanged )
      PubSub.subscribe( 'facebook:sdk:status:login', this._handleStatusLogin )
      PubSub.subscribe( 'mixpanel:sdk:track:event', this._handleMixpanelEvents )
      mixpanel.track_forms('#new_recommendation_form', 'activation:recommend')
      mixpanel.track_forms('#new_search_form','activation:search')

  render: ->
    `<meta property='MixpanelAPI' content={this.state.is_loaded} name={this.state.identity}/>`

  _handleStatusChanged: (msg, response) ->
    $.when(this._getFacebookData(response)).done (response) =>
      this.setState(identity: response.id)
      this._registerProperties(response)
      this._createProfile(response)
      mixpanel.people.increment('page views', 1)
      mixpanel.track('retention:page:view')
    
    if response.status == 'not_authorized'
      mixpanel.track('acquisition:unauthenticated')      

  _handleStatusLogin: (msg, response) ->
    mixpanel.track('acquisition:permissions:dialog')

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
  

  _registerProperties: (infomation) ->
    # link previous behaviour to this account 
    distinct_id = mixpanel.get_distinct_id()
    console.log "_registerProperties: #{distinct_id}"
    console.log "_registerProperties: #{infomation.id}"
    mixpanel.alias(infomation.id, distinct_id)
      
    if this.isFacebookCanvas() 
      platform = 'canvas'
    else
      platform = 'web'

    location = infomation.location if infomation.location

    mixpanel.register
      'Gender': infomation.gender
      'Location': location.name
      'Platform': platform


  _createProfile: (information) ->
    distinct_id = mixpanel.get_distinct_id()
    console.log "_createProfile: #{distinct_id}"
    console.log "_createProfile: #{infomation.id}"

    mixpanel.identify(information.id)
    mixpanel.people.set
      $email: information.email
      $first_name: information.first_name
      $last_name: information.last_name
      gender: information.gender
)