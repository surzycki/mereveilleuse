class SessionsController < ApplicationController
  # For the entry point we have to skip the authenticity validations, as the post is coming from facebook
  skip_before_filter :verify_authenticity_token, only: :create
  around_filter      :catch_exceptions, unless: 'Rails.env.development?'

  # non facebook canvas entry point
  # GET /session/new
  def new 
    if Rails.env.production?
      redirect_to not_found_path
    else 
      initialize_authentication_service
      
      authentication_service.authenticate FacebookAuthentication.stub(User.first)
    end
  end

  # POST /session
  def create 
    initialize_authentication_service

    authentication_service.authenticate facebook_authentication
  end

  # GET /session
  def show
    if current_user.registered?
      redirect_to new_search_path
    else
      redirect_to new_registration_path   
    end
  end

  private
  def initialize_authentication_service
    authentication_service.on :success do |account, redirect_path|
      # set user_id in env for the authentication since we
      # aren't passing these during a via params in a post for warden
      warden.set_user account, scope: :user
      
      if account.registered?
        redirect_to(redirect_path || new_search_path)
      else
        redirect_to new_registration_path   
      end
    end

    authentication_service.on :fail do |error|
      TrackError.new( error, logger ) if error
     
      redirect_to not_found_path
    end
  end

  # Facebook posts a signed_request to upon arriving to the canvas
  def facebook_authentication
    @facebook_authentication ||= FacebookAuthentication.new(params[:signed_request], params[:app_data])
  end

  def authentication_service
    @authentication_service ||= AuthenticationService.new 
  end

  def catch_exceptions
    yield
  rescue => error  
    TrackError.new( error, logger )

    redirect_to not_found_path
  end
end
