class SessionsController < ApplicationController
  around_filter      :catch_exceptions, unless: 'Rails.env.development?'
  before_filter      :initialize_authentication_service, only: [:new, :create]
  
  # non facebook canvas entry point
  # GET /session/new
  def new 
    if Rails.env.production?
      redirect_to not_found_path
    else 
      authentication_service.authenticate FacebookAuthentication.stub(User.first)
    end
  end

  # POST /session
  def create 
    authentication_service.authenticate facebook_authentication
  end

  private
  def initialize_authentication_service
    authentication_service.on :login do |account, redirect_path|
      # set user_id in env for the authentication since we
      # aren't passing these during a via params in a post for warden
      warden.set_user account, scope: :user
      
      redirect_to(redirect_path || new_search_path)
    end

    authentication_service.on :signup do |account|
      # set user_id in env for the authentication since we
      # aren't passing these during a via params in a post for warden
      warden.set_user account, scope: :user

      redirect_to new_registration_path
    end

    # display facebook authentication dialog
    authentication_service.on :request_authentication do |auth|
      redirect_to new_registration_path(requesting_authentication: true)
    end


    authentication_service.on :fail do |error|
      TrackError.new( error, env ) if error
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
    TrackError.new( error, env )
    redirect_to not_found_path
  end
end
